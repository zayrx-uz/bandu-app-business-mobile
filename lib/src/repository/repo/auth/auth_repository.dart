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
  Future<HttpResult> otp({
    required String otpToken,
    required String code,
  }) async {
    return await authProvider.otp(otpToken, code);
  }

  @override
  Future<HttpResult> register({
    required String phone,
    required String fullName,
    required String password,
    required String img,
    required String role,
  }) async {
    return await authProvider.register(phone, fullName, password, img, role);
  }

  @override
  Future<HttpResult> uploadImage({required String filePath}) async {
    return await authProvider.uploadImage(filePath);
  }
}
