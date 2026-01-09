import 'package:bandu_business/src/helper/api/api_helper.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:bandu_business/src/provider/api_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ApiProvider {
  ///login
  Future<HttpResult> login(String phone, String password, String role) async {
    String? d = await getToken();
    final body = {
      'phoneNumber': phone,
      'password': password,
      "role": role,
      "fcmToken": d,
    };
    return await postRequest(ApiHelper.login, body);
  }

  ///register
  Future<HttpResult> register(
    String phone,
    String fullName,
    String password,
    String img,
    String role,
  ) async {
    String? d = await getToken();

    final body = {
      'phoneNumber': phone,
      'fullName': fullName,
      'password': password,
      'role': role,
      'profilePicture': img,
      "fcmToken": d,
    };
    return await postRequest(ApiHelper.register, body);
  }

  Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  ///otp
  Future<HttpResult> otp(String otpToken, String code) async {
    final body = {'otpToken': otpToken, 'otp': code};
    return await postRequest(ApiHelper.otp, body);
  }

  ///forgot password
  Future<HttpResult> forgotPassword(String phoneNumber) async {
    final body = {'phoneNumber': phoneNumber};
    return await postRequest(ApiHelper.forgotPassword, body);
  }

  ///verify reset code
  Future<HttpResult> verifyResetCode(String phoneNumber, String code, String otpToken) async {
    final body = {
      'phoneNumber': phoneNumber,
      'code': code,
      'otpToken': otpToken,
    };
    return await postRequest(ApiHelper.verifyResetCode, body);
  }

  ///reset password
  Future<HttpResult> resetPassword(String resetToken, String newPassword) async {
    final body = {
      'resetToken': resetToken,
      'newPassword': newPassword,
    };
    return await postRequest(ApiHelper.resetPassword, body);
  }

  ///media
  Future<HttpResult> uploadImage(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiHelper.media));

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        filePath,
        contentType: MediaType('image', filePath.split(".").last),
      ),
    );

    return await postMultiRequest(request);
  }
}
