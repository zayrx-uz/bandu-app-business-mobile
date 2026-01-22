import 'dart:convert';
import 'dart:io';

import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class FirebaseHelper {
  /// Init Firebase and Local Notifications
  static Future<void> init() async {
    await Firebase.initializeApp();

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Android init
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // iOS actions & categories
    const String navigationActionId = 'id_3';
    const String darwinNotificationCategoryText = 'textCategory';
    const String darwinNotificationCategoryPlain = 'plainCategory';

    final List<DarwinNotificationCategory> darwinNotificationCategories = [
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: [
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: [
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: {DarwinNotificationActionOption.destructive},
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: {DarwinNotificationActionOption.authenticationRequired},
          ),
        ],
        options: {DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
      ),
    ];

    // iOS init
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: darwinNotificationCategories,
        );

    // Common init
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    // Initialize plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

      onDidReceiveBackgroundNotificationResponse: (response) {
        if (response.payload == null) return;

        final data = jsonDecode(response.payload!);
        if (data["verifyUrl"] != null) {
          RxBus.post(tag: "notification", data["verifyUrl"]);
        }
      },
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) return;

        final data = jsonDecode(response.payload!);
        if (data["verifyUrl"] != null) {
          RxBus.post(tag: "notification", data["verifyUrl"]);
        }
      },
    );

    // iOS specific
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  /// Request permission and setup listeners
  static Future<void> initNotification() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Ask for permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Handle cold start
    FirebaseMessaging.instance.getInitialMessage();

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message == null) return;
      RemoteNotification? notification = message.notification;
      // Show notification if chat is not open
      const androidDetails = AndroidNotificationDetails(
        'chanel_id',
        'channel_name',
        icon: "app_icon",
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
      );

      const iOSDetails = DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      );

      const notificationDetails = NotificationDetails(
        iOS: iOSDetails,
        android: androidDetails,
      );

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    });

    // When tapping on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      RxBus.post(tag: "notification", event.data["verifyUrl"]);
    });
  }

  /// Get FCM token - checks cache first, then fetches from Firebase if needed
  /// Works for both Android and iOS
  static Future<String?> getFcmToken() async {
    try {
      // First check cache
      String? cachedToken = CacheService.getString("fcm_token");
      if (cachedToken != null && cachedToken.isNotEmpty) {
        print('🔑 FCM Token (cache): $cachedToken');
        return cachedToken;
      }

      // If not in cache, fetch from Firebase
      print('📱 FCM Token cache da topilmadi, Firebase dan olinmoqda...');
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      if (Platform.isIOS) {
        // iOS specific handling
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        int retryCount = 0;
        const maxRetries = 5;
        String? token;

        while (retryCount < maxRetries && token == null) {
          await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));

          try {
            token = await messaging.getToken();
            if (token != null) {
              break;
            }
          } catch (e) {
            print('⏳ APNS token kutilmoqda... (${retryCount + 1}/$maxRetries)');
          }

          retryCount++;
        }

        if (token != null && token.isNotEmpty) {
          print('🔑 FCM Token (iOS): $token');
          CacheService.saveString("fcm_token", token);

          // Setup token refresh listener if not already set
          messaging.onTokenRefresh.listen((newToken) {
            print('🔄 FCM Token yangilandi: $newToken');
            CacheService.saveString("fcm_token", newToken);
          });

          return token;
        } else {
          print('❌ APNS token olishda xatolik. Token olinmadi.');
          return null;
        }
      } else {
        // Android handling
        String? token = await messaging.getToken();

        if (token != null && token.isNotEmpty) {
          print('🔑 FCM Token (Android): $token');
          CacheService.saveString("fcm_token", token);

          // Setup token refresh listener if not already set
          messaging.onTokenRefresh.listen((newToken) {
            print('🔄 FCM Token yangilandi: $newToken');
            CacheService.saveString("fcm_token", newToken);
          });

          return token;
        } else {
          print('❌ FCM token olishda xatolik');
          return null;
        }
      }
    } catch (e) {
      print('❌ FCM token olishda xatolik: $e');
      return null;
    }
  }
}
