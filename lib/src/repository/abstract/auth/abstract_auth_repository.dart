import 'package:bandu_business/src/model/response/http_result.dart';

abstract class AbstractAuthRepository {
  Future<HttpResult> login({
    required String phone,
    required String password,
    required String role,
  });

  Future<HttpResult> otp({
    required String otpToken,
    required String code,
  }) ;

  Future<HttpResult> registerComplete({
    required String role,
    required String fullName,
    required String token,
    required String password,
    required String fcmToken,
    String? profilePicture,
    String? gender,
  });

  Future<HttpResult> register({
    required String phone,
  }) ;

  Future<HttpResult> forgotPassword({required String phoneNumber});

  Future<HttpResult> verifyResetCode({
    required String phoneNumber,
    required String code,
    required String otpToken,
  });

  Future<HttpResult> resetPassword({
    required String resetToken,
    required String newPassword,
  });

  Future<HttpResult> uploadImage({required String filePath});

  Future<HttpResult> logout();
}
