import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
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
import 'package:bandu_business/src/ui/main/settings/settings_screen.dart';
import 'package:bandu_business/src/ui/main/statistic/statistic_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/dialog/bottom_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late BuildContext sheetContext;
  int select = 0;
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
    setBus();
    super.initState();
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

  String _getCategoryImage(int categoryId, bool isSelected) {
    switch (categoryId) {
      case 1:
        return isSelected ? AppImages.restaurantSelect : AppImages.restaurantUnselect;
      case 24:
        return isSelected ? AppImages.barberSelect : AppImages.barberUnselect;
      case 37:
        return isSelected ? AppImages.carwashSelect : AppImages.carwashUnselect;
      default:
        return isSelected ? AppImages.restaurantSelect : AppImages.restaurantUnselect;
    }
  }

  Widget buttons(String text, int index) {
    final isSelected = select == index;
    
    if (index == 1) {
      final categoryId = CacheService.getCategoryId() ?? 1;
      final imagePath = _getCategoryImage(categoryId, isSelected);
      
      return Expanded(
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  width: isTablet(context) ? 20.sp : 24.w,
                  height: isTablet(context) ? 20.sp : 24.w,
                  fit: BoxFit.cover,
                ),
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
  }
}
