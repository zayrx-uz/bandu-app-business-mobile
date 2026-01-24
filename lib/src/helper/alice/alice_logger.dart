// Alice (HTTP Inspector) — faqat debug rejimida. Release'da hech narsa ishlamaydi.

import 'dart:convert';

import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice/model/alice_http_call.dart';
import 'package:alice/model/alice_http_request.dart';
import 'package:alice/model/alice_http_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// HTTP Inspector — faqat kDebugMode da. Release build'da umuman ishlatilmaydi.
class AliceLogger {
  static Alice? _alice;

  static void init(GlobalKey<NavigatorState> navigatorKey) {
    if (!kDebugMode) return;
    _alice = Alice(
      configuration: AliceConfiguration(
        showNotification: true,
        showInspectorOnShake: true,
        navigatorKey: navigatorKey,
      ),
    );
    _alice?.setNavigatorKey(navigatorKey);
  }

  static void addHttpCall({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    dynamic requestBody,
    required http.Response response,
    required DateTime requestTime,
  }) {
    if (!kDebugMode || _alice == null) return;

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
      ..contentType =
          headers['content-type'] ?? headers['Content-Type'] ?? 'application/json'
      ..queryParameters = uri.queryParameters;

    if (requestBody != null) {
      final bodyStr =
          requestBody is String ? requestBody : json.encode(requestBody);
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
      ..duration = responseTime.millisecondsSinceEpoch -
          requestTime.millisecondsSinceEpoch;

    _alice!.addHttpCall(call);
  }

  static void showInspector() {
    if (!kDebugMode || _alice == null) return;
    _alice?.showInspector();
  }

  /// Faqat debug da va init qilingandan keyin true.
  static bool get isEnabled => kDebugMode && _alice != null;
}
