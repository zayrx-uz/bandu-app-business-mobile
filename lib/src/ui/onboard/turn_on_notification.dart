import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/ui/onboard/create_success.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

class TurnOnNotification extends StatefulWidget {
  const TurnOnNotification({super.key});

  @override
  State<TurnOnNotification> createState() => _TurnOnNotificationState();
}

class _TurnOnNotificationState extends State<TurnOnNotification>
    with SingleTickerProviderStateMixin {
  bool isOn = false;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _animationController.forward();
    }
  }

  Future<void> _toggleNotification() async {
    setState(() {
      isLoading = true;
    });

    bool tokenReceived = await _requestNotificationPermissionAndGetToken();

    setState(() {
      isLoading = false;
    });

    if (tokenReceived) {
      setState(() {
        isOn = true;
      });

      CacheService.saveBool("notif", true);

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        _navigateToNextScreen();
      }
    } else {
      CacheService.saveBool("notif", false);

      if (mounted) {
        CenterDialog.errorDialog(context, "notificationConnectionError".tr());

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          _navigateToNextScreen();
        }
      }
    }
  }

  Future<bool> _requestNotificationPermissionAndGetToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notification ruxsati berildi');

        if (Platform.isIOS) {
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

          if (token != null) {
            print('🔑 FCM Token (iOS): $token');
            CacheService.saveString("fcm_token", token);

            messaging.onTokenRefresh.listen((newToken) {
              print('🔄 FCM Token yangilandi: $newToken');
              CacheService.saveString("fcm_token", newToken);
            });

            return true;
          } else {
            print('❌ APNS token olishda xatolik. Token olinmadi.');
            return false;
          }
        } else {
          String? token = await messaging.getToken();

          if (token != null) {
            print('🔑 FCM Token (Android): $token');
            CacheService.saveString("fcm_token", token);

            messaging.onTokenRefresh.listen((newToken) {
              print('🔄 FCM Token yangilandi: $newToken');
              CacheService.saveString("fcm_token", newToken);
            });

            return true;
          } else {
            print('❌ FCM token olishda xatolik');
            return false;
          }
        }

      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('⚠️ Notification ruxsati rad etildi');
        return false;
      } else {
        print('⚠️ Notification ruxsati berilmadi');
        return false;
      }

    } catch (e) {
      print('❌ FCM token olishda xatolik: $e');
      return false;
    }
  }

  Future<void> _skipNotification() async {
    CacheService.saveBool("notif", false);

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    print("Navigate to next screen");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CreateSuccess()),
            (route)  => false
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Column(
            children: [
              SizedBox(height: 50.h),

              Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: const TopAppName(),
                ),
              ),

              SizedBox(height: 50.h),

              Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      !isOn ? AppImages.notifOff : AppImages.notifOn,
                      key: ValueKey<bool>(isOn),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Text(
                    "turnOnNotifications".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: Text(
                      "notificationsDescription".tr(),
                      style: TextStyle(
                        color: AppColor.c585B57,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: AppButton(
                    onTap: _toggleNotification,
                    text: "turnOn".tr(),
                    loading: isLoading,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: AppButton(
                    onTap: _skipNotification,
                    text: "maybeLater".tr(),
                    isGradient: false,
                    backColor: Colors.white,
                    border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
                    txtColor: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}