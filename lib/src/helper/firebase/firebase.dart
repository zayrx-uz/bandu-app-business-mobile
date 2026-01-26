import 'dart:convert';
import 'dart:io';

import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/model/api/main/notification/notification_model.dart';
import 'package:bandu_business/src/provider/main/home/home_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  if (response.payload == null) {
    RxBus.post(null, tag: "open_notification_screen");
    return;
  }
  
  try {
    final payload = jsonDecode(response.payload!);
    print("🔔 Background notification payload: $payload");
    
    if (payload is Map) {
      dynamic bookingId;
      
      if (payload.containsKey("booking_id")) {
        bookingId = payload["booking_id"];
        print("✅ Found booking_id in payload: $bookingId");
      } else if (payload.containsKey("id")) {
        bookingId = payload["id"];
        print("✅ Found id in payload: $bookingId");
      } else if (payload.containsKey("bookingId")) {
        bookingId = payload["bookingId"];
        print("✅ Found bookingId in payload: $bookingId");
      } else if (payload.containsKey("data")) {
        final data = payload["data"];
        print("📦 Found data field: $data (type: ${data.runtimeType})");
        if (data is Map) {
          if (data.containsKey("booking_id")) {
            bookingId = data["booking_id"];
            print("✅ Found booking_id in data: $bookingId");
          } else if (data.containsKey("id")) {
            bookingId = data["id"];
            print("✅ Found id in data: $bookingId");
          } else if (data.containsKey("bookingId")) {
            bookingId = data["bookingId"];
            print("✅ Found bookingId in data: $bookingId");
          } else {
            print("❌ No booking_id/id/bookingId in data map. Keys: ${data.keys.toList()}");
          }
        } else if (data is String) {
          try {
            final parsedData = jsonDecode(data);
            print("📦 Parsed data string: $parsedData");
            if (parsedData is Map) {
              if (parsedData.containsKey("booking_id")) {
                bookingId = parsedData["booking_id"];
                print("✅ Found booking_id in parsed data: $bookingId");
              } else if (parsedData.containsKey("id")) {
                bookingId = parsedData["id"];
                print("✅ Found id in parsed data: $bookingId");
              } else if (parsedData.containsKey("bookingId")) {
                bookingId = parsedData["bookingId"];
                print("✅ Found bookingId in parsed data: $bookingId");
              } else {
                print("❌ No booking_id/id/bookingId in parsed data. Keys: ${parsedData.keys.toList()}");
              }
            }
          } catch (e) {
            print("❌ Error parsing data string: $e");
          }
        }
      } else {
        print("❌ No booking_id/id/data in payload. Keys: ${payload.keys.toList()}");
      }
      
      if (bookingId != null) {
        print("🚀 Posting booking_notification with bookingId: $bookingId");
        RxBus.post(bookingId, tag: "booking_notification");
      } else if (payload.containsKey("verifyUrl")) {
        print("🚀 Posting notification with verifyUrl");
        RxBus.post(payload["verifyUrl"], tag: "notification");
      } else {
        print("⚠️ No bookingId found, checking notification API");
        FirebaseHelper._checkNotificationApiForBookingId();
      }
    } else {
      print("❌ Payload is not a Map, type: ${payload.runtimeType}");
      FirebaseHelper._checkNotificationApiForBookingId();
    }
  } catch (e) {
    print("❌ Error parsing payload: $e");
    FirebaseHelper._checkNotificationApiForBookingId();
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  RemoteNotification? notification = message.notification;
  if (notification == null) return;

  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'channel_name',
    icon: "app_icon",
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    enableVibration: true,
    showWhen: true,
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

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    notificationDetails,
    payload: jsonEncode(message.data),
  );
}

class FirebaseHelper {
  /// Init Firebase and Local Notifications
  static Future<void> init() async {
    await Firebase.initializeApp();
    
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

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) {
          _checkNotificationApiForBookingId();
          return;
        }
        
        try {
          final payload = jsonDecode(response.payload!);
          print("🔔 Notification payload: $payload");
          
          if (payload is Map) {
            dynamic bookingId;
            
            if (payload.containsKey("booking_id")) {
              bookingId = payload["booking_id"];
              print("✅ Found booking_id in payload: $bookingId");
            } else if (payload.containsKey("id")) {
              bookingId = payload["id"];
              print("✅ Found id in payload: $bookingId");
            } else if (payload.containsKey("bookingId")) {
              bookingId = payload["bookingId"];
              print("✅ Found bookingId in payload: $bookingId");
            } else if (payload.containsKey("data")) {
              final data = payload["data"];
              print("📦 Found data field: $data (type: ${data.runtimeType})");
              if (data is Map) {
                if (data.containsKey("booking_id")) {
                  bookingId = data["booking_id"];
                  print("✅ Found booking_id in data: $bookingId");
                } else if (data.containsKey("id")) {
                  bookingId = data["id"];
                  print("✅ Found id in data: $bookingId");
                } else if (data.containsKey("bookingId")) {
                  bookingId = data["bookingId"];
                  print("✅ Found bookingId in data: $bookingId");
                } else {
                  print("❌ No booking_id/id/bookingId in data map. Keys: ${data.keys.toList()}");
                }
              } else if (data is String) {
                try {
                  final parsedData = jsonDecode(data);
                  print("📦 Parsed data string: $parsedData");
                  if (parsedData is Map) {
                    if (parsedData.containsKey("booking_id")) {
                      bookingId = parsedData["booking_id"];
                      print("✅ Found booking_id in parsed data: $bookingId");
                    } else if (parsedData.containsKey("id")) {
                      bookingId = parsedData["id"];
                      print("✅ Found id in parsed data: $bookingId");
                    } else if (parsedData.containsKey("bookingId")) {
                      bookingId = parsedData["bookingId"];
                      print("✅ Found bookingId in parsed data: $bookingId");
                    } else {
                      print("❌ No booking_id/id/bookingId in parsed data. Keys: ${parsedData.keys.toList()}");
                    }
                  }
                } catch (e) {
                  print("❌ Error parsing data string: $e");
                }
              }
            } else {
              print("❌ No booking_id/id/data in payload. Keys: ${payload.keys.toList()}");
            }
            
            if (bookingId != null) {
              print("🚀 Posting booking_notification with bookingId: $bookingId");
              RxBus.post(bookingId, tag: "booking_notification");
            } else if (payload.containsKey("verifyUrl")) {
              print("🚀 Posting notification with verifyUrl");
              RxBus.post(payload["verifyUrl"], tag: "notification");
            } else {
              print("⚠️ No bookingId found, checking notification API");
              _checkNotificationApiForBookingId();
            }
          } else {
            print("❌ Payload is not a Map, type: ${payload.runtimeType}");
            _checkNotificationApiForBookingId();
          }
        } catch (e) {
          print("❌ Error parsing payload: $e");
          _checkNotificationApiForBookingId();
        }
      },
    );

    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      await androidImplementation?.createNotificationChannel(
        const AndroidNotificationChannel(
          'high_importance_channel',
          'channel_name',
          description: 'High importance notifications',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );
    }

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
        'high_importance_channel',
        'channel_name',
        icon: "app_icon",
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        showWhen: true,
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      final eventData = event.data;
      print("🔔 onMessageOpenedApp event data: $eventData");
      if (eventData.isEmpty) {
        print("⚠️ Event data is empty, checking notification API");
        _checkNotificationApiForBookingId();
        return;
      }
      
      dynamic bookingId;
      
      if (eventData.containsKey("booking_id")) {
        bookingId = eventData["booking_id"];
        print("✅ Found booking_id in eventData: $bookingId");
      } else if (eventData.containsKey("id")) {
        bookingId = eventData["id"];
        print("✅ Found id in eventData: $bookingId");
      } else if (eventData.containsKey("bookingId")) {
        bookingId = eventData["bookingId"];
        print("✅ Found bookingId in eventData: $bookingId");
      } else if (eventData.containsKey("data")) {
        try {
          final dataStr = eventData["data"];
          print("📦 Found data field: $dataStr (type: ${dataStr.runtimeType})");
          if (dataStr is String) {
            final data = jsonDecode(dataStr);
            print("📦 Parsed data string: $data");
            if (data is Map) {
              if (data.containsKey("booking_id")) {
                bookingId = data["booking_id"];
                print("✅ Found booking_id in parsed data: $bookingId");
              } else if (data.containsKey("id")) {
                bookingId = data["id"];
                print("✅ Found id in parsed data: $bookingId");
              } else if (data.containsKey("bookingId")) {
                bookingId = data["bookingId"];
                print("✅ Found bookingId in parsed data: $bookingId");
              } else {
                print("❌ No booking_id/id/bookingId in parsed data. Keys: ${data.keys.toList()}");
              }
            }
          } else if (dataStr is Map) {
            if (dataStr.containsKey("booking_id")) {
              bookingId = dataStr["booking_id"];
              print("✅ Found booking_id in data map: $bookingId");
            } else if (dataStr.containsKey("id")) {
              bookingId = dataStr["id"];
              print("✅ Found id in data map: $bookingId");
            } else if (dataStr.containsKey("bookingId")) {
              bookingId = dataStr["bookingId"];
              print("✅ Found bookingId in data map: $bookingId");
            } else {
              print("❌ No booking_id/id/bookingId in data map. Keys: ${dataStr.keys.toList()}");
            }
          }
        } catch (e) {
          print("❌ Error parsing data: $e");
        }
      } else {
        print("❌ No booking_id/id/data in eventData. Keys: ${eventData.keys.toList()}");
      }
      
      if (bookingId != null) {
        print("🚀 Posting booking_notification with bookingId: $bookingId");
        RxBus.post(bookingId, tag: "booking_notification");
      } else if (eventData.containsKey("verifyUrl")) {
        print("🚀 Posting notification with verifyUrl");
        RxBus.post(eventData["verifyUrl"], tag: "notification");
      } else {
        print("⚠️ No bookingId found, checking notification API");
        _checkNotificationApiForBookingId();
      }
    });
  }

  static Future<void> _checkNotificationApiForBookingId() async {
    try {
      final provider = HomeProvider();
      final result = await provider.getNotifications(page: 1, limit: 1);
      
      if (result.isSuccess && result.result != null) {
        try {
          final model = NotificationModel.fromJson(result.result);
          if (model.data.isNotEmpty) {
            final firstNotification = model.data.first;
            if (firstNotification.bookingId != null && firstNotification.bookingId! > 0) {
              print("✅ Found bookingId from API: ${firstNotification.bookingId}");
              RxBus.post(firstNotification.bookingId, tag: "booking_notification");
              return;
            }
          }
        } catch (e) {
          print("❌ Error parsing notification model: $e");
        }
      }
      
      print("⚠️ No bookingId found in API, opening notification screen");
      RxBus.post(null, tag: "open_notification_screen");
    } catch (e) {
      print("❌ Error checking notification API: $e");
      RxBus.post(null, tag: "open_notification_screen");
    }
  }

  /// Get FCM token - checks cache first, then fetches from Firebase if needed
  /// Works for both Android and iOS
  static Future<String?>  getFcmToken() async {
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
