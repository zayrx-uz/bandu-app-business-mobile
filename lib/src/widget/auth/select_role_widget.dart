import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectRoleWidget extends StatelessWidget {
  final Function(String) role;

  const SelectRoleWidget({super.key, required this.role});

  // English role names - always in English regardless of app language
  static const List<String> _englishRoles = [
    "Business Owner",
    "Moderator",
    "Manager",
    "Worker",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("companyRole".tr(), style: AppTextStyle.f500s16),
          SizedBox(height: 6.h),
          DropdownFlutter<String>(
            hintText: "selectRole".tr(),
            excludeSelected: false,
            hideSelectedFieldWhenExpanded: true,
            canCloseOutsideBounds: false,
            decoration: CustomDropdownDecoration(
              closedFillColor: AppColor.greyFA,
              expandedFillColor: AppColor.white,
              closedSuffixIcon: AppSvgAsset(AppIcons.bottom),
              expandedSuffixIcon: Container(),
              closedBorder: Border.all(width: 1.h, color: AppColor.greyE5),
              headerStyle: AppTextStyle.f500s16,
            ),
            items: _englishRoles,
            listItemBuilder: (a, b, s, d) {
              return Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      height: 16.h,
                      width: 16.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.greyFA,
                        border: Border.all(
                          width: s ? 4.h : 1.h,
                          color: s ? AppColor.yellowFFC : AppColor.greyE5,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(child: Text(b, style: AppTextStyle.f400s16)),
                  ],
                ),
              );
            },
            onChanged: (value) {
              role(value ?? '');
            },
          ),
        ],
      ),
    );
  }
}
