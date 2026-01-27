import 'dart:io' show Platform;

import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotifTestScreen extends StatefulWidget {
  const NotifTestScreen({super.key});

  @override
  State<NotifTestScreen> createState() => _NotifTestScreenState();
}

class _NotifTestScreenState extends State<NotifTestScreen> {
  String? fcmToken;
  String? apnsToken;
  bool isLoading = true;
  String? errorMessage;
  String? warningMessage;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetToken();
  }

  Future<void> _requestPermissionAndGetToken() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        warningMessage = null;
        apnsToken = null;
        fcmToken = null;
      });

      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      final NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        setState(() {
          errorMessage = "Notification permission rad etildi";
          isLoading = false;
        });
        return;
      }

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        setState(() {
          errorMessage = "Permission berilmadi";
          isLoading = false;
        });
        return;
      }

      if (Platform.isIOS) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // Avval FCM token olish (retry bilan). APNS tokenni keyinroq olish.
      String? token;
      const maxRetries = 12;
      int attempts = 0;

      while (attempts < maxRetries) {
        try {
          token = await messaging.getToken();
          if (token != null && token.isNotEmpty) break;
        } on FirebaseException catch (e) {
          if (e.code == 'messaging/apns-token-not-set' ||
              e.message?.contains('APNS') == true) {
            // APNS hali tayyor emas, biroz kutilib qayta urinamiz
            await Future.delayed(Duration(seconds: 1 + (attempts ~/ 2)));
            attempts++;
            continue;
          }
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1));
        attempts++;
      }

      if (token != null && token.isNotEmpty) {
        CacheService.saveString("fcm_token", token);
        setState(() => fcmToken = token);
      }

      // iOS da APNS tokenni ko‘rsatish uchun (ixtiyoriy)
      if (Platform.isIOS) {
        String? apns;
        for (int i = 0; i < 5; i++) {
          apns = await messaging.getAPNSToken();
          if (apns != null) {
            CacheService.saveString("apns_token", apns);
            setState(() => apnsToken = apns);
            break;
          }
          await Future.delayed(const Duration(milliseconds: 800));
        }
        if (apnsToken == null) {
          setState(() => warningMessage =
              "APNS token olinmadi. Simulator da push ishlamaydi — haqiqiy qurilmada sinab ko‘ring. Xcode: Push Notifications + Background Modes (Remote notifications) yoqilgan bo‘lishi kerak.");
        }
      }

      if (fcmToken == null) {
        setState(() {
          errorMessage = Platform.isIOS
              ? "FCM token olinmadi. Haqiqiy qurilmada sinab ko‘ring (simulator da push ishlamaydi). Xcode: Push Notifications va Background Modes yoqilgan bo‘lishi kerak."
              : "FCM token olinmadi";
          isLoading = false;
        });
        return;
      }

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        errorMessage = "Xatolik: $e";
        isLoading = false;
      });
    }
  }

  void _copyToken(String token, String type) {
    Clipboard.setData(ClipboardData(text: token));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$type token nusxalandi!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildTokenCard(String title, String? token, String type) {
    if (token == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  type == 'FCM' ? Icons.android : Icons.apple,
                  color: type == 'FCM' ? Colors.green : Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                token,
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _copyToken(token, type),
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Nusxalash'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Token Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _requestPermissionAndGetToken,
            tooltip: 'Yangilash',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      Platform.isIOS
                          ? 'FCM / APNS token kutilmoqda...'
                          : 'Token yuklanmoqda...',
                    ),
                  ],
                )
              : errorMessage != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _requestPermissionAndGetToken,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Qayta urinish'),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 48,
                          ),
                          const SizedBox(height: 24),
                          if (warningMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline, color: Colors.amber[800]),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      warningMessage!,
                                      style: TextStyle(
                                        color: Colors.amber[900],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (apnsToken != null)
                            _buildTokenCard(
                                'APNS Token (iOS)', apnsToken, 'APNS'),
                          if (fcmToken != null)
                            _buildTokenCard('FCM Token', fcmToken, 'FCM'),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
