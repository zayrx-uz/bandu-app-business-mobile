import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/model/api/main/home/category_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCategoryWidget extends StatelessWidget {
  final Function(int) onSelect;
  final List<CategoryData> item;

  const SelectCategoryWidget({
    super.key,
    required this.onSelect,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Category", style: AppTextStyle.f500s16),
          SizedBox(height: 8.h),
          DropdownFlutter<CategoryData>(
            hintText: 'Select role',
            excludeSelected: false,
            hideSelectedFieldWhenExpanded: true,
            headerBuilder: (context, a, b) {
              return Text(a.name, style: AppTextStyle.f400s16);
            },
            canCloseOutsideBounds: false,
            decoration: CustomDropdownDecoration(
              closedFillColor: AppColor.greyFA,
              expandedFillColor: AppColor.white,
              closedSuffixIcon: AppSvgAsset(AppIcons.bottom),
              expandedSuffixIcon: Container(),
              closedBorder: Border.all(width: 1.h, color: AppColor.greyE5),
            ),
            items: item,
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
                    Expanded(child: Text(b.name, style: AppTextStyle.f400s16)),
                  ],
                ),
              );
            },
            onChanged: (value) {
              onSelect(value?.id ?? 0);
            },
          ),
        ],
      ),
    );
  }
}
