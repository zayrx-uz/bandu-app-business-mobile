import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiptItemWidget extends StatelessWidget {
  final String title;
  final String data;
  final String? leftIcon;
  final Color? dataColor;
  final bool isLast;

  const ReceiptItemWidget({
    super.key,
    required this.title,
    required this.data,
    this.leftIcon,
    this.dataColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isLast
          ? EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w)
          : EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(width: 1.h, color: AppColor.greyE5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.f400s12.copyWith(color: AppColor.grey58),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              if (leftIcon != null) ...[
                AppSvgAsset(leftIcon!, height: 20.h, width: 20.h),
                SizedBox(width: 4.w),
              ],
              Expanded(
                child: Text(
                  data,
                  style: AppTextStyle.f600s14.copyWith(
                    color: dataColor ?? AppColor.black09,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
