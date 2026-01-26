import 'package:bandu_business/src/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class SelectLanguageItem extends StatelessWidget {
  const SelectLanguageItem({
    super.key,
    required this.image,
    required this.text,
    required this.isSelect, required this.onTap,
  });

  final String image;
  final String text;
  final bool isSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColor.cF4F5F4,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
              ),
              child: Center(
                child: Image.asset(image, width: 20.w, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            Spacer(),
            isSelect
                ? Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppColor.yellowFFC,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Center(
                      child: Container(
                        width: 10.w,

                        height: 10.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppColor.cF4F5F4,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
