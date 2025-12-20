import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployerItemWidget extends StatefulWidget {
  final EmployeeItemData data;

  const EmployerItemWidget({super.key, required this.data});

  @override
  State<EmployerItemWidget> createState() => _EmployerItemWidgetState();
}

class _EmployerItemWidgetState extends State<EmployerItemWidget>
    with SingleTickerProviderStateMixin {
  bool open = false;

  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  void toggle() {
    setState(() {
      open = !open;
      open ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EmployeeItemData data = widget.data;
    return GestureDetector(
      onTap: toggle,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColor.white,
          border: Border.all(width: 1.h, color: AppColor.greyE5),
        ),
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  CustomNetworkImage(
                    imageUrl: data.profilePicture,
                    height: 48.h,
                    width: 48.h,
                    borderRadius: 100,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.fullName,
                          maxLines: 1,
                          style: AppTextStyle.f500s16,
                        ),
                        Text(
                          data.role.toUpperCase(),
                          style: AppTextStyle.f400s14.copyWith(
                            color: AppColor.grey58,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Rotating arrow
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: AppIconButton(icon: AppIcons.bottom, onTap: toggle),
                  ),
                ],
              ),
            ),

            /// EXPANDABLE AREA
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  children: [
                    Divider(height: 1, color: AppColor.greyE5),

                    SizedBox(height: 12.h),

                    /// PHONE NUMBER
                    _rowItem(
                      "Phone number",
                      data.authProviders.first.phoneNumber.phoneFormat(),
                    ),

                    SizedBox(height: 12.h),

                    /// CONTACT STATUS
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Text(
                            "Contact status",
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.grey58,
                            ),
                          ),
                          SizedBox(width: 32.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppColor.black,
                            ),
                            child: Text(
                              data.role,
                              style: AppTextStyle.f500s14.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),
                    Divider(height: 1, color: AppColor.greyE5),
                    SizedBox(height: 12.h),

                    /// BUTTONS
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                    'tel:${data.authProviders.first.phoneNumber.phoneFormat()}',
                                  ),
                                );
                              },
                              height: 40.h,
                              isGradient: false,
                              backColor: AppColor.white,
                              margin: EdgeInsets.zero,
                              text: "Call person",
                              txtColor: AppColor.black,
                              leftIcon: AppIcons.call,
                              border: Border.all(
                                width: 1.h,
                                color: AppColor.greyE5,
                              ),
                            ),
                          ),
                          // SizedBox(width: 12.w),
                          // AppIconButton(
                          //   icon: AppIcons.menu,
                          //   onTap: () {},
                          //   height: 40.h,
                          //   width: 40.h,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyle.f400s16.copyWith(color: AppColor.grey58),
          ),
          SizedBox(width: 32.w),
          Text(value, style: AppTextStyle.f400s16),
        ],
      ),
    );
  }
}
