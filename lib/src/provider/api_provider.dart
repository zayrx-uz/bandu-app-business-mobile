// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../helper/service/rx_bus.dart';

class ApiProvider {
  static const Duration _timeout = Duration(seconds: 120);

  /// 🔹 POST request
  Future<HttpResult> postRequest(
    String url,
    dynamic body, {
    bool isCaptcha = false,
  }) async {
    final headers = _header();
    _logRequest('POST', url, headers, body);

    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(_timeout);

      return _result(response);
    } on TimeoutException catch (_) {
      return _networkError();
    } on SocketException catch (_) {
      return _networkError();
    }
  }

  /// 🔹 Multipart POST request
  Future<HttpResult> postMultiRequest(http.MultipartRequest request) async {
    request.headers.addAll(_header(isMultipart: true));
    _logRequest(
      'POST MULTIPART',
      request.url.toString(),
      request.headers,
      request.fields,
    );

    final streamedResponse = await request.send().timeout(
      Duration(seconds: 120),
    );
    final response = await http.Response.fromStream(streamedResponse);

    _logResponse(response);
    return _result(response);
  }

  /// 🔹 GET request
  Future<HttpResult> getRequest(String url, {bool withHeader = true}) async {
    final headers = withHeader ? _header() : null;
    _logRequest('GET', url, headers);

    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(_timeout);
      return _result(response);
    } on TimeoutException catch (_) {
      return _networkError();
    } on SocketException catch (_) {
      return _networkError();
    }
  }

  /// 🔹 DELETE request
  Future<HttpResult> deleteRequest(String url) async {
    final headers = _header();
    _logRequest('DELETE', url, headers);

    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(_timeout);
      return _result(response);
    } on TimeoutException catch (_) {
      return _networkError();
    } on SocketException catch (_) {
      return _networkError();
    }
  }

  /// 🔹 PUT request
  Future<HttpResult> putRequest(String url, dynamic body) async {
    final headers = _header();
    _logRequest('PUT', url, headers, body);

    try {
      final response = await http
          .put(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(_timeout);

      return _result(response);
    } on TimeoutException catch (_) {
      return _internetError();
    } on SocketException catch (_) {
      return _internetError();
    }
  }

  /// 🔹 PATCH request
  Future<HttpResult> patchRequest(String url, dynamic body) async {
    final headers = _header();
    _logRequest('PATCH', url, headers, body);

    try {
      final response = await http
          .patch(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(_timeout);

      return _result(response);
    } on TimeoutException catch (_) {
      return _internetError();
    } on SocketException catch (_) {
      return _internetError();
    }
  }

  /// 🔹 HTTP javobni qayta ishlash
  HttpResult _result(http.Response response) {
    _logResponse(response);

    final status = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (status >= 200 && status < 300) {
      return HttpResult(
        isSuccess: true,
        status: status,
        result: json.decode(body),
      );
    }

    if (status == 401 || status == 409) {
      RxBus.post(1, tag: "CLOSED_USER");
    }

    try {
      return HttpResult(
        isSuccess: false,
        status: status,
        result: json.decode(body),
      );
    } catch (_) {
      return HttpResult(
        isSuccess: false,
        status: status,
        result: "Server error",
      );
    }
  }

  /// 🔹 Headerlarni tayyorlash
  Map<String, String> _header({bool isMultipart = false}) {
    final token = CacheService.getString('access_token');
    final headers = <String, String>{
      'Accept': isMultipart ? '*/*' : 'application/json',
      'lang': 'en',
    };

    if (token.isNotEmpty) {
      headers['Authorization'] = "Bearer $token";
    }

    headers['content-type'] = isMultipart
        ? "multipart/form-data"
        : 'application/json';
    return headers;
  }

  /// 🔹 Request log
  void _logRequest(String method, String url, dynamic headers, [dynamic body]) {
    if (kDebugMode) {
      log('//// ==== $method REQUEST ==== ////');
      log('URL: $url');
      log('Headers: $headers');
      if (body != null) log('Body: ${json.encode(body)}');
    }
  }

  /// 🔹 Response log
  void _logResponse(http.Response response) {
    if (kDebugMode) {
      log('//// ==== RESPONSE ==== ////');
      log('Status: ${response.statusCode}');
      log('Body: ${response.body}');
    }
  }

  /// 🔹 Network xatolik
  HttpResult _networkError() =>
      HttpResult(isSuccess: false, status: -1, result: "Network");

  /// 🔹 Internet xatolik
  HttpResult _internetError() =>
      HttpResult(isSuccess: false, status: -1, result: "Internet error");
}
