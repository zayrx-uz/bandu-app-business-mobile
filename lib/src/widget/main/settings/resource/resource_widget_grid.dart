import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart'
    hide Image;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourceWidgetGrid extends StatelessWidget {
  const ResourceWidgetGrid({super.key, required this.data});

  final Datum data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        data.images.isNotEmpty
            ? CustomNetworkImage(
          imageUrl: data.images.first.url,
          borderRadius: 12.r,
          width: double.infinity,
          height: 112.h,
          fit: BoxFit.cover,
        ) : Container(
          height: 112.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.food,
              width: 64.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 11.h,),
        Row(
          children: [
            Flexible(
              child: Text(
                data.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${data.price.formatWithSpaces()} UZS",
              style: TextStyle(
                color: AppColor.yellowFFC,
                fontSize: 16.sp,
                letterSpacing: -1,
                fontWeight: FontWeight.w900,
              ),
            ),
            AppSvgAsset(AppIcons.threeDot , width: 20.w,fit : BoxFit.cover)
          ],
        )
      ],
    );
  }
}
