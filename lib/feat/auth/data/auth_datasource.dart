
import 'package:katlavan24/core/constants/network_constants.dart';
import 'package:katlavan24/core/models/token_model.dart';
import 'package:katlavan24/core/models/user_model.dart';
import 'package:katlavan24/core/network/dio_client.dart';

abstract class AuthDataSource {
  Future<void> getOtp(String number);

  Future<Token> verifyOtp(String number, String pin);

  Future<User> getUserProfile();
}

final class AuthDataSourceImpl extends AuthDataSource {
  AuthDataSourceImpl();

  final dio = DioClient();

  @override
  Future<void> getOtp(String number) async {
    try {
      final response = await dio.postRequest(NetworkConstants.getOtp, data: {'phone_number': "+998$number"});
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Token> verifyOtp(String number, String pin) async {
    try {
      final response = await dio.postRequest(
        NetworkConstants.verifyOtp,
        data: {'phone_number': '+998$number', 'otp_code': pin},
      );
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw response;
      } else{
        return Token.fromMap(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUserProfile() async {
    try {
      final response = await dio.getRequest(NetworkConstants.userProfile);
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw response;
      } else {
        return User.fromMap(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }
}
