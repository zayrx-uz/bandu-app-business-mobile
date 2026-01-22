import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/booking/owner_booking_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/main/booking/booking_detail_bottom_sheet.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/dialog/bottom_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingItemWidget extends StatelessWidget {
  final OwnerBookingItemData data;
  final bool showStatus;

  const BookingItemWidget({
    super.key,
    required this.data,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final homeBloc = BlocProvider.of<HomeBloc>(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (bottomSheetContext) {
            return EasyLocalization(
              supportedLocales: const [
                Locale('en', 'EN'),
                Locale('ru', 'RU'),
                Locale('uz', 'UZ'),
              ],
              path: 'assets/translations',
              startLocale:
              EasyLocalization.of(context)?.locale ??
                  const Locale('ru', 'RU'),
              fallbackLocale: const Locale('ru', 'RU'),
              child: BlocProvider.value(
                value: homeBloc,
                child: BookingDetailBottomSheet(
                  bookingId: data.id,
                  parentBloc: homeBloc,
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(width: 1.h, color: AppColor.greyE5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                  imageUrl: data.user.profilePicture ?? "",
                  height: 56.h,
                  width: 56.h,
                  fit: BoxFit.cover,
                  borderRadius: 12.r,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.user.fullName,
                        style: AppTextStyle.f500s20,
                      ),
                      Text(
                        data.bookingTime?.toDDMMYYY() ?? "",
                        style: AppTextStyle.f400s16.copyWith(
                          color: AppColor.grey58,
                        ),
                      ),
                    ],
                  ),
                ),
                AppIconButton(icon: AppIcons.arrowBottom, onTap: (){
                  final homeBloc = BlocProvider.of<HomeBloc>(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (bottomSheetContext) {
                      return EasyLocalization(
                        supportedLocales: const [
                          Locale('en', 'EN'),
                          Locale('ru', 'RU'),
                          Locale('uz', 'UZ'),
                        ],
                        path: 'assets/translations',
                        startLocale:
                        EasyLocalization.of(context)?.locale ??
                            const Locale('ru', 'RU'),
                        fallbackLocale: const Locale('ru', 'RU'),
                        child: BlocProvider.value(
                          value: homeBloc,
                          child: BookingDetailBottomSheet(
                            bookingId: data.id,
                            parentBloc: homeBloc,
                          ),
                        ),
                      );
                    },
                  );
                } ,iconWidth: 14.w,)
              ],
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              color: AppColor.greyF4,
            ),
            Row(
              children: [
                Expanded(
                  child: showStatus
                      ? Container(
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              width: 1.h,
                              color: AppColor.greyE5,
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _getStatusText(data.status),
                                style: AppTextStyle.f600s16.copyWith(
                                  color: _getStatusColor(data.status),
                                  fontSize: 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        )
                      : AppButton(
                          onTap: () async {
                            BottomDialog.bookCancel(context, bookingId: data.id);
                          },
                          height: 48.h,
                          margin: EdgeInsets.zero,
                          isGradient: false,
                          backColor: AppColor.white,
                          text: "cancelBooking".tr(),
                          style: AppTextStyle.f600s16.copyWith(
                            color: AppColor.cE52E4C,
                          ),
                          border: Border.all(
                            width: 1.h,
                            color: AppColor.cE52E4C,
                          ),
                          leftIcon: AppIcons.trash,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    return status.getLocalizedStatus();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColor.grey58;
      case 'confirmed':
        return AppColor.yellow8E;
      case 'canceled':
        return AppColor.cE52E4C;
      case 'completed':
        return Colors.green;
      default:
        return AppColor.grey58;
    }
  }
}
