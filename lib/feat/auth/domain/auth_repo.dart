import 'package:katlavan24/core/models/token_model.dart';
import 'package:katlavan24/core/models/user_model.dart';
import 'package:katlavan24/feat/auth/data/auth_datasource.dart';

abstract class AuthRepository {
  Future<void> getOtp(String number);

  Future<Token> verifyOtp(String number, String pin);

  Future<User> getUserProfile();
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> getOtp(String number) async {
    try {
      return await dataSource.getOtp(number);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<User> getUserProfile() async {
    try {
      return await dataSource.getUserProfile();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Token> verifyOtp(String number, String pin) async {
    try {
      return await dataSource.verifyOtp(number, pin);
    } catch (e) {
      rethrow;
    }
  }
}
