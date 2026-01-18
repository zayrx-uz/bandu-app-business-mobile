import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
  import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart'
      hide Image;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourceWidget extends StatelessWidget {
  const ResourceWidget({super.key, required this.data});

  final Datum data;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          width: double.infinity,
          child: Row(
            children: [
              data.images.isNotEmpty
                  ? CustomNetworkImage(
                      imageUrl: data.images.first.url,
                      borderRadius: 12.r,
                      width: 56.w,
                      height: 56.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.0),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          width: 1.w,
                          color : AppColor.cE5E7E5
                        )
                      ),
                      child: Center(child: SvgPicture.asset(AppIcons.food , width: 32.w,fit : BoxFit.cover))
                    ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          data.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 18.w,),
                        Text(
                          data.resourceCategory != null ? data.resourceCategory!.name : "",
                          style: TextStyle(
                            color: AppColor.cA7AAA7,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h,),
                    Text(
                      "${data.price.formatWithSpaces()} UZS",
                      style: TextStyle(
                        color: AppColor.yellowFFC,
                        fontSize: 16.sp,
                        letterSpacing: -1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(AppIcons.threeDot , width: 20.w,fit : BoxFit.cover)
            ],
          ),
        );
      },
    );
  }
}
