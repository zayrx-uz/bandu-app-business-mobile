import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:bandu_business/src/provider/auth/auth_provider.dart';
import 'package:bandu_business/src/repository/abstract/auth/abstract_auth_repository.dart';

class AuthRepository implements AbstractAuthRepository {
  final authProvider = AuthProvider();

  @override
  Future<HttpResult> login({
    required String phone,
    required String password,
    required String role,
  }) async {
    return await authProvider.login(phone, password, role);
  }


  @override
  Future<HttpResult> forgotPassword({required String phoneNumber}) async {
    return await authProvider.forgotPassword(phoneNumber);
  }

  @override
  Future<HttpResult> verifyResetCode({
    required String phoneNumber,
    required String code,
    required String otpToken,
  }) async {
    return await authProvider.verifyResetCode(phoneNumber, code, otpToken);
  }

  @override
  Future<HttpResult> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    return await authProvider.resetPassword(resetToken, newPassword);
  }

  @override
  Future<HttpResult> otp({
    required String otpToken,
    required String code,
  }) async {
    return await authProvider.otp(otpToken, code);
  }


  @override
  Future<HttpResult> registerComplete({
    required String role,
    required String fullName,
    required String token,
    required String password,
    required String fcmToken,
  }) async {
    return await authProvider.registerComplete(role: role, fullName: fullName, token: token, password: password, fcmToken: fcmToken);
  }

  @override
  Future<HttpResult> register({
    required String phone,
  }) async {
    return await authProvider.register(phone);
  }



  @override
  Future<HttpResult> uploadImage({required String filePath}) async {
    return await authProvider.uploadImage(filePath);
  }
}
