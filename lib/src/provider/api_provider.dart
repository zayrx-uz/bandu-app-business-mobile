// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bandu_business/src/helper/alice/alice_logger.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../helper/service/rx_bus.dart';

class ApiProvider {
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

      if (AliceLogger.isEnabled) {
        AliceLogger.addHttpCall(
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

    if (AliceLogger.isEnabled) {
      final requestBody = request.fields.toString();
      AliceLogger.addHttpCall(
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
      
      if (AliceLogger.isEnabled) {
        AliceLogger.addHttpCall(
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
      
      if (AliceLogger.isEnabled) {
        AliceLogger.addHttpCall(
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
      
      if (AliceLogger.isEnabled) {
        AliceLogger.addHttpCall(
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
      
      if (AliceLogger.isEnabled) {
        AliceLogger.addHttpCall(
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


    if (kDebugMode) {
      log("Mana u backdan kelgan response: $status");
    }


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
}
