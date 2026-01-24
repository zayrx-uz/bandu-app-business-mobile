// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:alice/model/alice_http_call.dart';
import 'package:alice/model/alice_http_request.dart';
import 'package:alice/model/alice_http_response.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../helper/service/rx_bus.dart';

class ApiProvider {
  static Alice? alice;
  static const Duration _timeout = Duration(seconds: 120);

  Future<HttpResult> postRequest(
    String url,
    dynamic body, {
    bool isCaptcha = false,
  }) async {
    final headers = _header();
    _logRequest('POST', url, headers, body);

    final requestBody = json.encode(body);
    final uri = Uri.parse(url);

    final requestTime = DateTime.now();
    try {
      final response = await http
          .post(uri, headers: headers, body: requestBody)
          .timeout(_timeout);

      if (kDebugMode && alice != null) {
        _addAliceCall(
          method: 'POST',
          uri: uri,
          headers: headers,
          requestBody: requestBody,
          response: response,
          requestTime: requestTime,
        );
      }

      return _result(response);
    } on TimeoutException catch (_) {
      return _networkError();
    } on SocketException catch (_) {
      return _networkError();
    }
  }

  Future<HttpResult> postMultiRequest(http.MultipartRequest request) async {
    request.headers.addAll(_header(isMultipart: true));
    _logRequest(
      'POST MULTIPART',
      request.url.toString(),
      request.headers,
      request.fields,
    );

    final requestTime = DateTime.now();
    final streamedResponse = await request.send().timeout(
      Duration(seconds: 120),
    );
    final response = await http.Response.fromStream(streamedResponse);

    if (kDebugMode && alice != null) {
      final requestBody = request.fields.toString();
      _addAliceCall(
        method: 'POST',
        uri: request.url,
        headers: request.headers,
        requestBody: requestBody,
        response: response,
        requestTime: requestTime,
      );
    }

    _logResponse(response);
    return _result(response);
  }

  Future<HttpResult> getRequest(String url, {bool withHeader = true}) async {
    final headers = withHeader ? _header() : null;
    _logRequest('GET', url, headers);

    try {
      final uri = Uri.parse(url);
      final request = http.Request('GET', uri);
      if (headers != null) {
        request.headers.addAll(headers);
      }
      
      final requestTime = DateTime.now();
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode && alice != null) {
        _addAliceCall(
          method: 'GET',
          uri: uri,
          headers: headers ?? {},
          requestBody: null,
          response: response,
          requestTime: requestTime,
        );
      }
      
      return _result(response);
    } on TimeoutException catch (_) {
      return _networkError();
    } on SocketException catch (_) {
      return _networkError();
    }
  }

  Future<HttpResult> deleteRequest(String url) async {
    final headers = _header();
    _logRequest('DELETE', url, headers);

    try {
      final uri = Uri.parse(url);
      final request = http.Request('DELETE', uri);
      request.headers.addAll(headers);
      
      final requestTime = DateTime.now();
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode && alice != null) {
        _addAliceCall(
          method: 'DELETE',
          uri: uri,
          headers: headers,
          requestBody: null,
          response: response,
          requestTime: requestTime,
        );
      }
      
      return _result(response);
    } on TimeoutException catch (_) {
      return _networkError();
    } on SocketException catch (_) {
      return _networkError();
    }
  }

  Future<HttpResult> putRequest(String url, dynamic body) async {
    final headers = _header();
    _logRequest('PUT', url, headers, body);

    try {
      final uri = Uri.parse(url);
      final requestBody = json.encode(body);
      final request = http.Request('PUT', uri);
      request.headers.addAll(headers);
      request.body = requestBody;
      
      final requestTime = DateTime.now();
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode && alice != null) {
        _addAliceCall(
          method: 'PUT',
          uri: uri,
          headers: headers,
          requestBody: requestBody,
          response: response,
          requestTime: requestTime,
        );
      }
      
      return _result(response);
    } on TimeoutException catch (_) {
      return _internetError();
    } on SocketException catch (_) {
      return _internetError();
    }
  }

  Future<HttpResult> patchRequest(String url, dynamic body) async {
    final headers = _header();
    _logRequest('PATCH', url, headers, body);

    try {
      final uri = Uri.parse(url);
      final requestBody = json.encode(body);
      final request = http.Request('PATCH', uri);
      request.headers.addAll(headers);
      request.body = requestBody;
      
      final requestTime = DateTime.now();
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode && alice != null) {
        _addAliceCall(
          method: 'PATCH',
          uri: uri,
          headers: headers,
          requestBody: requestBody,
          response: response,
          requestTime: requestTime,
        );
      }
      
      return _result(response);
    } on TimeoutException catch (_) {
      return _internetError();
    } on SocketException catch (_) {
      return _internetError();
    }
  }

  HttpResult _result(http.Response response) {
    _logResponse(response);

    final status = response.statusCode;
    final body = utf8.decode(response.bodyBytes);


    print("Mana u backdan kelgan responce $status}" );


    if (status >= 200 && status < 300) {
      return HttpResult(
        isSuccess: true,
        status: status,
        result: json.decode(body),
      );
    }
    if (status >= 500) {
      return HttpResult(
        isSuccess: false,
        status: 500,
        result: "Server bilan bog'liq muammo",
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

  Map<String, String> _header({bool isMultipart = false}) {
    final token = CacheService.getString('access_token');
    final savedLang = CacheService.getString('language');
    
    // Get current language, default to 'ru' if not set
    String lang = 'ru';
    if (savedLang.isNotEmpty) {
      final langLower = savedLang.toLowerCase();
      if (langLower == 'uz' || langLower == 'en' || langLower == 'ru') {
        lang = langLower;
      }
    }
    
    final headers = <String, String>{
      'Accept': isMultipart ? '*/*' : 'application/json',
      'lang': lang,
    };

    if (token.isNotEmpty) {
      headers['Authorization'] = "Bearer $token";
    }

    headers['content-type'] = isMultipart
        ? "multipart/form-data"
        : 'application/json';
    return headers;
  }

  void _logRequest(String method, String url, dynamic headers, [dynamic body]) {
    if (kDebugMode) {
      log('//// ==== $method REQUEST ==== ////');
      log('URL: $url');
      log('Headers: $headers');
      if (body != null) log('Body: ${json.encode(body)}');
    }
  }

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      log('//// ==== RESPONSE ==== ////');
      log('Status: ${response.statusCode}');
      log('Body: ${response.body}');
    }
  }

  HttpResult _networkError() =>
      HttpResult(isSuccess: false, status: -1, result: "Network");

  HttpResult _internetError() =>
      HttpResult(isSuccess: false, status: -1, result: "Internet error");

  void _addAliceCall({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    dynamic requestBody,
    required http.Response response,
    required DateTime requestTime,
  }) {
    if (alice == null) return;

    final call = AliceHttpCall(uri.hashCode)
      ..client = 'HttpClient (http package)'
      ..method = method
      ..uri = uri.toString()
      ..endpoint = uri.path.isEmpty ? '/' : uri.path
      ..server = uri.host
      ..secure = uri.scheme == 'https';

    final httpRequest = AliceHttpRequest()
      ..time = requestTime
      ..headers = headers
      ..contentType = headers['content-type'] ?? headers['Content-Type'] ?? 'application/json'
      ..queryParameters = uri.queryParameters;

    if (requestBody != null) {
      final bodyStr = requestBody is String ? requestBody : json.encode(requestBody);
      httpRequest
        ..body = bodyStr
        ..size = utf8.encode(bodyStr).length;
    } else {
      httpRequest
        ..body = ''
        ..size = 0;
    }

    final responseTime = DateTime.now();
    final responseBody = utf8.decode(response.bodyBytes);
    final httpResponse = AliceHttpResponse()
      ..status = response.statusCode
      ..body = responseBody
      ..size = utf8.encode(responseBody).length
      ..time = responseTime
      ..headers = Map<String, String>.from(response.headers);

    call
      ..request = httpRequest
      ..response = httpResponse
      ..loading = false
      ..duration = responseTime.millisecondsSinceEpoch - requestTime.millisecondsSinceEpoch;

    alice!.addHttpCall(call);
  }
}
