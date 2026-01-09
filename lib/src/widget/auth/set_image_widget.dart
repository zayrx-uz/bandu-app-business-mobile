import 'dart:io';

import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart' as home;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bounce/bounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class SetImageWidget extends StatelessWidget {
  final XFile? img;
  final String? networkImage;
  final bool isHome;

  const SetImageWidget({
    super.key,
    this.img,
    this.networkImage,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80.h,
              width: 80.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColor.greyE5,
                border: Border.all(width: 1.h, color: AppColor.white),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: -1,
                    color: AppColor.black0A.withValues(alpha: .04),
                  ),
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: -2,
                    color: AppColor.black0A.withValues(alpha: .03),
                  ),
                  BoxShadow(
                    offset: Offset(0, 12),
                    blurRadius: 16,
                    spreadRadius: -4,
                    color: AppColor.black0A.withValues(alpha: .08),
                  ),
                ],
              ),
              child: img != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.file(
                        File(img!.path),
                        height: 80.h,
                        width: 80.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : networkImage != null
                  ? CustomNetworkImage(
                      imageUrl: networkImage!,
                      height: 80.h,
                      width: 80.h,
                      fit: BoxFit.cover,
                      borderRadius: 16.r,
                    )
                  : Center(child: Text("AA", style: AppTextStyle.f600s24)),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              button("takeSelfie".tr(), true, context),
              SizedBox(width: 12.w),
              button("uploadPicture".tr(), false, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget button(String text, bool isSelfie, BuildContext context) {
    return Expanded(
      child: Bounce(
        onTap: () {
          if (isHome) {
            BlocProvider.of<home.HomeBloc>(
              context,
            ).add(home.GetImageEvent(isSelfie: isSelfie));
          } else {
            BlocProvider.of<AuthBloc>(
              context,
            ).add(GetImageEvent(isSelfie: isSelfie));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColor.white,
            border: Border.all(width: 1.h, color: AppColor.greyE5),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: AppColor.black0D.withValues(alpha: .06),
              ),
            ],
          ),
          child: Center(child: Text(text, style: AppTextStyle.f600s14.copyWith(
            fontSize: isTablet(context) ? 10.sp : 14.sp
          ))),
        ),
      ),
    );
  }
}
