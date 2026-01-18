import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectTypeWidget extends StatelessWidget {
  final bool? isAvaible;
  final Function(bool) onTap;

  const SelectTypeWidget({
    super.key,
    required this.isAvaible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("availability".tr(), style: AppTextStyle.f500s16),
          SizedBox(height: 6.h),
          Row(
            children: [
              selectButton(context, "available".tr(), isAvaible, () {
                onTap(true);
              }),
              SizedBox(width: 8.w),
              selectButton(
                context,
                "booked".tr(),
                isAvaible != null ? !isAvaible! : null,
                    () {
                  onTap(false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget selectButton(
      BuildContext context,
      String name,
      bool? isActive,
      Function() onTap,
      ) {
    return Expanded(
      child: CupertinoButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        child: Container(
          height: 48.h,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: isActive != null && isActive
                ? AppColor.yellowEF
                : AppColor.greyFA,
            border: Border.all(
              width: 1.h,
              color: isActive != null && isActive
                  ? AppColor.yellowFF
                  : AppColor.greyE5,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 20.h,
                width: 20.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive != null && isActive
                        ? AppColor.yellow8E
                        : AppColor.greyE5,
                    width: isActive != null && isActive ? 4.h : 1.5.h,
                  ),
                  color: isActive != null && isActive
                      ? AppColor.white
                      : AppColor.greyFA,
                ),
              ),
              SizedBox(width: 10.w,),
              Expanded(child: Text(name, style: AppTextStyle.f500s16)),

            ],
          ),
        ),
      ),
    );
  }
}
