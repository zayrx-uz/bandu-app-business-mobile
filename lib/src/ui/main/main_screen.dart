import 'dart:convert';

import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/employer/employer_screen.dart';
import 'package:bandu_business/src/ui/main/place/place_screen.dart';
import 'package:bandu_business/src/ui/main/qr/qr_screen.dart';
import 'package:bandu_business/src/ui/main/qr/screen/qr_booking_screen.dart';
import 'package:bandu_business/src/model/api/main/notification/notification_model.dart';
import 'package:bandu_business/src/provider/main/home/home_provider.dart';
import 'package:bandu_business/src/ui/main/booking/booking_detail_screen.dart';
import 'package:bandu_business/src/ui/main/settings/notification_screen/notification_screen.dart';
import 'package:bandu_business/src/ui/main/settings/settings_screen.dart';
import 'package:bandu_business/src/ui/main/statistic/statistic_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/dialog/bottom_dialog.dart';
import 'package:bandu_business/src/widget/main/booking/booking_detail_bottom_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late BuildContext sheetContext;
  int select = 0;
  bool _hasOpenedBookingDetailFromNotification = false;
  List<String> icon = [
    AppIcons.home,
    AppIcons.building,
    AppIcons.employe,
    AppIcons.settings,
  ];
  List<String> iconSelect = [
    AppIcons.homeOn,
    AppIcons.placeOn,
    AppIcons.employeOn,
    AppIcons.settingsOn,
  ];

  @override
  void initState() {
    super.initState();
    setBus();
    _checkInitialNotification();
  }

  Future<void> _checkInitialNotification() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final eventData = initialMessage.data;
          if (eventData.isEmpty) {
            RxBus.post(null, tag: "open_notification_screen");
            return;
          }
          
          dynamic bookingId;
          
          if (eventData.containsKey("booking_id")) {
            bookingId = eventData["booking_id"];
          } else if (eventData.containsKey("id")) {
            bookingId = eventData["id"];
          } else if (eventData.containsKey("data")) {
            try {
              final dataStr = eventData["data"];
              if (dataStr is String) {
                final data = jsonDecode(dataStr);
                if (data is Map) {
                  if (data.containsKey("booking_id")) {
                    bookingId = data["booking_id"];
                  } else if (data.containsKey("id")) {
                    bookingId = data["id"];
                  }
                }
              } else if (dataStr is Map) {
                if (dataStr.containsKey("booking_id")) {
                  bookingId = dataStr["booking_id"];
                } else if (dataStr.containsKey("id")) {
                  bookingId = dataStr["id"];
                }
              }
            } catch (e) {
            }
          }
          
          if (bookingId != null) {
            RxBus.post(bookingId, tag: "booking_notification");
          } else if (eventData.containsKey("verifyUrl")) {
            RxBus.post(eventData["verifyUrl"], tag: "notification");
          } else {
            RxBus.post(null, tag: "open_notification_screen");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          sheetContext = context;
          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Scaffold(
              body: [
                BlocProvider(
                  create: (_) => HomeBloc(homeRepository: HomeRepository()),
                  child: StatisticScreen(),
                ),
                BlocProvider(
                  create: (_) => HomeBloc(homeRepository: HomeRepository()),
                  child: PlaceScreen(),
                ),
                BlocProvider(
                  create: (_) => HomeBloc(homeRepository: HomeRepository()),
                  child: EmployerScreen(),
                ),
                BlocProvider(
                  create: (_) => HomeBloc(homeRepository: HomeRepository()),
                  child: SettingsScreen(),
                ),
              ][select],
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 24.h, top: 12.h),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border(
                        top: BorderSide(width: 1.h, color: AppColor.greyE5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buttons("home".tr(), 0),
                        buttons("places".tr(), 1),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            AppService.changePage(context, QrScreen());
                          },
                          child: Container(
                            height: 44.h,
                            width: 44.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColor.buttonGradient,
                            ),
                            child: Center(child: AppSvgAsset(AppIcons.scan)),
                          ),
                        ),
                        buttons("employer".tr(), 2),
                        buttons("settings".tr(), 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buttons(String text, int index) {
    final isSelected = select == index;
    
    if (index == 1) {
      final placeIconUrl = CacheService.getPlaceIcon();
      
      return Expanded(
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                if (placeIconUrl.isNotEmpty)
                  SizedBox(
                    width: isTablet(context) ? 20.sp : 24.w,
                    height: isTablet(context) ? 20.sp : 24.w,
                    child: placeIconUrl.endsWith('.svg')
                        ? SvgPicture.network(
                            placeIconUrl,
                            width: isTablet(context) ? 20.sp : 24.w,
                            height: isTablet(context) ? 20.sp : 24.w,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              isSelected ? AppColor.yellow8E : AppColor.greyA7,
                              BlendMode.srcIn,
                            ),
                          )
                        : Image.network(
                            placeIconUrl,
                            width: isTablet(context) ? 20.sp : 24.w,
                            height: isTablet(context) ? 20.sp : 24.w,
                            fit: BoxFit.contain,
                          ),
                  )
                else ...[
                  Builder(
                    builder: (context) {
                      final ikpuCode = CacheService.getCategoryIkpuCode();
                      final imagePath = ikpuCode.isNotEmpty 
                          ? HelperFunctions.getCategoryIconByIkpuCodeWithSelection(ikpuCode, isSelected)
                          : (isSelected ? AppIcons.placeSelect : AppIcons.place);
                      
                      return imagePath.contains('assets/images/')
                          ? Image.asset(
                              imagePath,
                              width: isTablet(context) ? 20.sp : 24.w,
                              height: isTablet(context) ? 20.sp : 24.w,
                              fit: BoxFit.cover,
                            )
                          : AppSvgAsset(
                              imagePath,
                              width: isTablet(context) ? 20.sp : 24.w,
                              height: isTablet(context) ? 20.sp : 24.w,
                            );
                    },
                  ),
                ],
                SizedBox(height: 4.h),
                Text(
                  text,
                  maxLines: 1,
                  style: AppTextStyle.f500s10.copyWith(
                    color: isSelected ? AppColor.yellow8E : AppColor.greyA7,
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            select = index;
            setState(() {});
          },
        ),
      );
    }
    
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              AppSvgAsset(isSelected ? iconSelect[index] : icon[index] , width : isTablet(context) ? 20.sp : 24.w , height: isTablet(context) ? 20.sp : 24.w,),
              SizedBox(height: 4.h),
              Text(
                text,
                maxLines: 1,
                style: AppTextStyle.f500s10.copyWith(
                  color: isSelected ? AppColor.yellow8E : AppColor.greyA7,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          select = index;
          setState(() {});
        },
      ),
    );
  }

  void setBus() async {
    RxBus.register(tag: "CLOSED_USER").listen((d) {
      CacheService.clear();
      if (!context.mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      AppService.replacePage(context, OnboardScreen());
    });

    RxBus.register(tag: "SERVER_ERROR").listen((d) {
      BottomDialog.serverError(context);
    });

    RxBus.register(tag: "NO_CONNECTION").listen((d) {
      BottomDialog.noConnection(context);
    });

    RxBus.register(tag: "notification").listen((url) async {
      await CupertinoScaffold.showCupertinoModalBottomSheet(
        context: sheetContext,
        builder: (ctx) => BlocProvider(
          create: (_) => HomeBloc(homeRepository: HomeRepository()),
          child: QrBookingScreen(dt: url),
        ),
      );
    });

    RxBus.register(tag: "booking_notification").listen((bookingId) async {
      if (!mounted) return;
      
      int? id;
      if (bookingId is int) {
        id = bookingId;
      } else if (bookingId is String) {
        id = int.tryParse(bookingId);
      } else if (bookingId is num) {
        id = bookingId.toInt();
      }
      
      if (id == null || id <= 0) return;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppService.changePage(
          sheetContext,
          BlocProvider(
            create: (_) => HomeBloc(homeRepository: HomeRepository()),
            child: BookingDetailScreen(bookingId: id!),
          ),
        );
      });
    });

    RxBus.register(tag: "language_changed").listen((d) {
      if (mounted) {
        setState(() {});
      }
    });

    RxBus.register(tag: "CHANGE_TAB").listen((index) {
      if (mounted && index is int) {
        select = index;
        setState(() {});
      }
    });

    RxBus.register(tag: "PLACE_ICON_UPDATED").listen((d) {
      if (mounted) {
        setState(() {});
      }
    });

    RxBus.register(tag: "open_notification_screen").listen((d) async {
      if (!mounted) return;
      
      final provider = HomeProvider();
      final result = await provider.getNotifications(page: 1, limit: 1);
      
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        
        int? bookingId;
        
        if (result.isSuccess && result.result != null) {
          try {
            final model = NotificationModel.fromJson(result.result);
            if (model.data.isNotEmpty) {
              final firstNotification = model.data.first;
              if (firstNotification.bookingId != null && firstNotification.bookingId! > 0) {
                bookingId = firstNotification.bookingId;
              }
            }
          } catch (e) {
          }
        }
        
        if (bookingId != null && bookingId > 0) {
          AppService.changePage(
            sheetContext,
            BlocProvider(
              create: (_) => HomeBloc(homeRepository: HomeRepository()),
              child: BookingDetailScreen(bookingId: bookingId),
            ),
          );
        } else {
          AppService.changePage(sheetContext, const NotificationScreen());
        }
      });
    });
  }
}
