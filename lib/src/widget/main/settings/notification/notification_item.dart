import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 1.w,
          color : AppColor.cE5E7E5
        )
      ),
      child : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("New 10 Services added!" , style: TextStyle(
            color : Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500
          ),),
          SizedBox(height: 8.h,),
          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt dolor sit amet. " , style: TextStyle(
              color : AppColor.c666970,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500
          ),),
          SizedBox(height: 12.h,),
          Row(
            children: [
              SvgPicture.asset(AppIcons.calendar , width: 16.w,fit : BoxFit.cover),
              SizedBox(width: 4.w,),
              Text("Saturday, 08:05" , style: TextStyle(
                color : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp
              ),)
            ],
          )
        ],
      )
    );
  }
}
