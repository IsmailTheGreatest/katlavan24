import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:katlavan24/core/constants/network_constants.dart';
import 'package:katlavan24/core/enums/auth_status.dart';
import 'package:katlavan24/core/models/token_model.dart';
import 'package:katlavan24/core/models/user_model.dart';
import 'package:katlavan24/core/services/cache_service.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  DioClient() {
    _dio.interceptors.add(ApiInterceptors(_getNewAccessToken));
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Dio get dio => _dio;

  void setTokenToHeader(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  void removeTokenToHeader() {
    _dio.options.headers.remove("Authorization");
    _dio.options.headers["Authorization"] = "";
  }

  Future<AuthenticationStatus> init() async {
    log('init started');
    final result = await Connectivity().checkConnectivity();

    if (result.contains(ConnectivityResult.none)) {
      return AuthenticationStatus.disabledInternet;
    } else {
      final isConnected = await InternetConnectionChecker.instance.hasConnection;
      if (!isConnected) {
        return AuthenticationStatus.connectionFailed;
      }
    }
    Token? token = await TokenService().getItem();
    if (token == null) return AuthenticationStatus.unauthenticated;

    try {
      if (await _isAuthenticated(token)) return AuthenticationStatus.authenticated;
      await TokenService().deleteItem();
      String? newAccessToken = await _getNewAccessToken(token.refreshToken);
      if (newAccessToken == null) {
        return AuthenticationStatus.unauthenticated;
      }

      return await _isAuthenticated(token.copyWith(accessToken: newAccessToken))
          ? AuthenticationStatus.authenticated
          : AuthenticationStatus.unauthenticated;
    } catch (e, trace) {
      log(trace.toString());
      return AuthenticationStatus.connectionFailed;
    }
  }

  Future<bool> _isAuthenticated(Token token) async {
    try {
      Response response = await getRequest(NetworkConstants.userProfile);
      if (response.statusCode == 200) {
        await UserService().setItem(User.fromMap(response.data));
        return true;
      }
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
    }
    return false;
  }

  Future<String?> _getNewAccessToken(String refreshToken) async {
    _dio.options.headers.remove('Authorization');
    try {
      final response = await _sendRequest('POST', NetworkConstants.refreshToken, data: {'refresh': refreshToken});
      Token? token = await TokenService().getItem();
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final newAccessToken = response.data['access'];
        await TokenService().setItem(token!.copyWith(accessToken: newAccessToken));

        return newAccessToken;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Function get getNewAccessToken => _getNewAccessToken;

  Future<Response> _sendRequest(String method, String endpoint,
      {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    try {
      late Response response;

      switch (method) {
        case 'GET':
          response = await _dio.get(endpoint, queryParameters: queryParameters, options: Options(headers: headers));
          break;
        case 'POST':
          response = await _dio.post(endpoint, data: data, options: Options(headers: headers));
          break;
        case 'PUT':
          response = await _dio.put(endpoint, data: data, options: Options(headers: headers));
          break;
        case 'DELETE':
          response = await _dio.delete(endpoint, queryParameters: queryParameters, options: Options(headers: headers));
          break;
        case 'PATCH':
          response = await _dio.patch(endpoint, data: data, options: Options(headers: headers));
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> _sendMultipartRequest(String method, String endpoint,
      {Map<String, dynamic>? data, Map<String, dynamic>? headers}) async {
    try {
      final formData = FormData.fromMap(data ?? {});
      late Response response;
      switch (method) {
        case 'POST':
          response = await _dio.post(
            endpoint,
            data: formData,
            options: Options(headers: headers),
          );
          break;
        case 'PATCH':
          response = await _dio.patch(
            endpoint,
            data: formData,
            options: Options(headers: headers),
          );
          break;
        default:
          throw Exception('Unsupported HTTP method for multipart: $method');
      }
      return response;
    } on DioException catch (e) {
      throw Exception("Multipart $method so'rovi xatolik yuz berdi: ${e.message}");
    }
  }

  Future<Response> getRequest(String endpoint, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) {
    return _sendRequest('GET', endpoint, queryParameters: queryParameters, headers: headers);
  }

  Future<Response> postRequest(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return _sendRequest('POST', endpoint, data: data, headers: headers);
  }

  Future<Response> putRequest(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return _sendRequest('PUT', endpoint, data: data, headers: headers);
  }

  Future<Response> deleteRequest(String endpoint,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) {
    return _sendRequest('DELETE', endpoint, queryParameters: queryParameters, headers: headers);
  }

  Future<Response> patchRequest(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return _sendRequest('PATCH', endpoint, data: data, headers: headers);
  }

  Future<Response> multipartPostRequest(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return _sendMultipartRequest('POST', endpoint, data: data, headers: headers);
  }

  Future<Response> multipartPatchRequest(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) {
    return _sendMultipartRequest('PATCH', endpoint, data: data, headers: headers);
  }
}

class ApiInterceptors extends Interceptor {
  ApiInterceptors(this.getNewAccessToken);

  Future<String?> Function(String) getNewAccessToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.validateStatus = (status) => status != null && status < 500;

    if (!options.path.contains('/auth/refresh-token/')) {
      Token? token = await TokenService().getItem();
      if (token != null) options.headers["Authorization"] = "Bearer ${token.accessToken}";
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      if (response.realUri.toString().contains('token/refresh/')) {
        await TokenService().deleteItem();
        return;
      }
      Token? token = await TokenService().getItem();

      String? newAccessToken = await DioClient().getNewAccessToken(token?.refreshToken);
      if (newAccessToken == null) {
        await TokenService().deleteItem();
      }
    }

    super.onResponse(response, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('Request  [${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('Response [${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('Error    [${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
