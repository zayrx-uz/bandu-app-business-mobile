import 'dart:io';
import 'package:bandu_business/src/helper/api/api_helper.dart';
import 'package:bandu_business/src/helper/firebase/firebase.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:bandu_business/src/provider/api_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AuthProvider extends ApiProvider {
  static String _getDeviceId() {
    String? deviceId = CacheService.getString("device_id");
    if (deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      CacheService.saveString("device_id", deviceId);
    }
    return deviceId;
  }

  static String _getPlatform() {
    return Platform.isIOS ? "ios" : "android";
  }

  Future<HttpResult> login(String phone, String password, String role) async {
    String? fcmToken = await FirebaseHelper.getFcmToken();
    final body = {
      'phoneNumber': phone,
      'password': password,
      "useType": "BUSINESS",
      "fcmToken": fcmToken ?? "",
      "deviceId": _getDeviceId(),
      "platform": _getPlatform(),
    };
    return await postRequest(ApiHelper.login, body);
  }

  ///register
  Future<HttpResult> register(
      String phone,
      ) async {
    final Map<String, dynamic> body = {
      'phoneNumber': phone,
      'useType': 'BUSINESS',
    };

    // if (img != null) {
    //   body['profilePicture'] = img;
    // }

    return await postRequest(ApiHelper.register, body);
  }

  ///otp
  Future<HttpResult> otp(String otpToken, String code) async {
    final body = {'otpToken': otpToken, 'otp': code};
    return await postRequest(ApiHelper.otp, body);
  }


  Future<HttpResult> registerComplete({
    required String role,
    required String fullName,
    required String token,
    required String password,
    required String fcmToken,
    String? profilePicture,
    String? gender,
  }) async {
    final body = {
      "registrationToken": token,
      "fullName": fullName,
      "password": password,
      "useType": "BUSINESS",
      "fcmToken": fcmToken,
      "deviceId": _getDeviceId(),
      "platform": _getPlatform(),
    };
    return await postRequest(ApiHelper.registerComplete, body);
  }

  ///forgot password
  Future<HttpResult> forgotPassword(String phoneNumber) async {
    final body = {'phoneNumber': phoneNumber ,   "useType": "BUSINESS"};
    return await postRequest(ApiHelper.forgotPassword, body);
  }

  ///verify reset code
  Future<HttpResult> verifyResetCode(String phoneNumber, String code, String otpToken) async {
    final body = {
      'phoneNumber': phoneNumber,
      'code': code,
      'otpToken': otpToken,
      "useType": "BUSINESS"
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

  ///delete account
  Future<HttpResult> deleteAccount() async {
    return await deleteRequest(ApiHelper.deleteAccount);
  }

  ///logout
  Future<HttpResult> logout() async {
    return await postRequest(ApiHelper.logout, {});
  }
}
