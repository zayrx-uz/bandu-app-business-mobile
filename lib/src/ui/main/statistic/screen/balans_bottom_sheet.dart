import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/statistic/screen/revenue_statistic_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalansBottomSheet extends StatefulWidget {
  final int totalRevenue;

  const BalansBottomSheet({
    super.key,
    required this.totalRevenue,
  });

  @override
  State<BalansBottomSheet> createState() => _BalansBottomSheetState();
}

class _BalansBottomSheetState extends State<BalansBottomSheet> {
  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(homeRepository: HomeRepository()),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            top: false,
            child: _showChart
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: const RevenueStatisticScreen(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 12.h),
                      Center(
                        child: Container(
                          width: 36.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColor.greyE5,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "dailyRevenue".tr(),
                                style: AppTextStyle.f600s18,
                              ),
                            ),
                            AppIconButton(
                              icon: AppIcons.close,
                              onTap: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(height: 0.5.h, color: AppColor.greyE5),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "${widget.totalRevenue.priceFormat()} UZS",
                          style: AppTextStyle.f600s24,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                        child: AppButton(
                          onTap: () => setState(() => _showChart = true),
                          text: "viewStatistics".tr(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
