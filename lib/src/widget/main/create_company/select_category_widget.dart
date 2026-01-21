import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/model/api/main/home/category_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Function(int) onSelect;
  final List<CategoryData> item;
  final int? selectedId;

  const SelectCategoryWidget({
    super.key,
    required this.onSelect,
    required this.item,
    this.selectedId,
  });

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    CategoryData? initialItem;
    if (widget.selectedId != null) {
      try {
        initialItem = widget.item.firstWhere((cat) => cat.id == widget.selectedId);
      } catch (e) {
        initialItem = null;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("selectCategory".tr(), style: AppTextStyle.f500s16.copyWith(
            fontSize:  isTablet(context) ? 12.sp : 16.sp
          )),
          SizedBox(height: 8.h),
          DropdownFlutter<CategoryData>(
            key: ValueKey(widget.selectedId),
            hintText: "selectCategory".tr(),
            initialItem: initialItem,
            excludeSelected: false,
            hideSelectedFieldWhenExpanded: false,
            headerBuilder: (context, defaultItem, isExpanded) {
              if (initialItem != null) {
                return Text(
                  initialItem.name,
                  style: AppTextStyle.f400s16.copyWith(
                    fontSize: isTablet(context) ? 12.sp : 16.sp
                  ),
                );
              }
              return Text(
                "selectCategory".tr(),
                style: AppTextStyle.f400s16.copyWith(
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                  color: Colors.grey,
                ),
              );
            },
            canCloseOutsideBounds: false,
            decoration: CustomDropdownDecoration(
              closedFillColor: AppColor.greyFA,
              expandedFillColor: AppColor.white,
              closedSuffixIcon: AppSvgAsset(AppIcons.bottom),
              expandedSuffixIcon: Container(),
              closedBorder: Border.all(width: 1.h, color: AppColor.greyE5),
            ),
            items: widget.item,
            listItemBuilder: (a, b, s, d) {
              final isSelected = widget.selectedId == b.id;
              return Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Container(
                      height: 16.h,
                      width: 16.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.greyFA,
                        border: Border.all(
                          width: isSelected ? 4.h : 1.h,
                          color: isSelected ? AppColor.yellowFFC : AppColor.greyE5,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        b.name,
                        style: AppTextStyle.f400s16.copyWith(
                          fontSize: isTablet(context) ? 12.sp : 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            onChanged: (value) {
              if (value != null) {
                widget.onSelect(value.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
