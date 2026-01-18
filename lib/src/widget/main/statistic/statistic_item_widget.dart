import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/booking/bookings_screen.dart';
import 'package:bandu_business/src/ui/main/statistic/screen/statistic_view_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StatisticItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;

  const StatisticItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        if (title == "occupiedPlaces".tr()) {
          AppService.changePage(
            context,
            BlocProvider(
              create: (_) => HomeBloc(homeRepository: HomeRepository()),
              child: const BookingsScreen(),
            ),
          );
        } else {
          CupertinoScaffold.showCupertinoModalBottomSheet(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: const StatisticViewScreen(),
              );
            },
          );
        }
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColor.white,
          border: Border.all(width: 1.h, color: AppColor.greyE5),
        ),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColor.greyFA,
                      border: Border.all(width: 1.h, color: AppColor.greyE5),
                    ),
                    child: Center(
                      child: AppSvgAsset(icon, color: AppColor.black),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyle.f400s14.copyWith(
                            color: AppColor.grey58,
                          ),
                        ),
                        Text(
                         desc,
                          style: AppTextStyle.f600s24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColor.greyFA,
                border: Border(
                  top: BorderSide(width: 1.h, color: AppColor.greyE5),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "seeDetails".tr(),
                      style: AppTextStyle.f400s14.copyWith(
                        color: AppColor.grey58,
                      ),
                    ),
                  ),
                  AppSvgAsset(AppIcons.more),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
