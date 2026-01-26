import 'package:bandu_business/src/helper/firebase/firebase.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotifTestScreen extends StatefulWidget {
  const NotifTestScreen({super.key});

  @override
  State<NotifTestScreen> createState() => _NotifTestScreenState();
}

class _NotifTestScreenState extends State<NotifTestScreen> {
  String? fcmToken;
  bool isLoading = true;
  String? errorMessage;

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
      });

      // Firebase Messaging instance
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Permission so'rash
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Permission berildi, tokenni olish
        String? token = await messaging.getToken();

        if (token != null) {
          // Tokenni cache ga saqlash
           CacheService.saveString("fcm_token", token);

          setState(() {
            fcmToken = token;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Token olinmadi";
            isLoading = false;
          });
        }
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        setState(() {
          errorMessage = "Notification permission rad etildi";
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Permission berilmadi";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Xatolik: $e";
        isLoading = false;
      });
    }
  }

  void _copyToken() {
    if (fcmToken != null) {
      Clipboard.setData(ClipboardData(text: fcmToken!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('FCM token nusxalandi!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('FCM token yuklanmoqda...'),
                  ],
                )
              else if (errorMessage != null)
                Column(
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
              else if (fcmToken != null)
                  Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'FCM Token:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          fcmToken!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _copyToken,
                        icon: const Icon(Icons.copy),
                        label: const Text('Tokenni nusxalash'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}