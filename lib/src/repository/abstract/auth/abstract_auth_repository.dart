import 'package:bandu_business/src/model/response/http_result.dart';

abstract class AbstractAuthRepository {
  Future<HttpResult> login({
    required String phone,
    required String password,
    required String role,
  });

  Future<HttpResult> register({
    required String phone,
    required String fullName,
    required String password,
    required String img,
    required String role,
  });

  Future<HttpResult> otp({required String otpToken, required String code});

  Future<HttpResult> uploadImage({required String filePath});
}
