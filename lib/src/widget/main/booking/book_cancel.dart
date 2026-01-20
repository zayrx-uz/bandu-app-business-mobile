import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookCancel extends StatefulWidget {
  final int bookingId;
  final HomeBloc? parentBloc;

  const BookCancel({super.key, required this.bookingId, this.parentBloc});

  @override
  State<BookCancel> createState() => _BookCancelState();
}

class _BookCancelState extends State<BookCancel> {
  bool haveProblem = false;
  bool textField = false;
  String selectText = "";

  TextEditingController controller = TextEditingController();

  String _getNote() {
    if (selectText.isEmpty) return "";
    final lastReason = cancelReasons.last;
    if (selectText == lastReason && controller.text.isNotEmpty) {
      return controller.text;
    }
    return selectText;
  }

  @override
  Widget build(BuildContext context) {
    // Use existing bloc if available, otherwise create new one
    HomeBloc? existingBloc;
    try {
      existingBloc = context.read<HomeBloc>();
    } catch (e) {
      existingBloc = null;
    }
    
    return existingBloc != null
        ? BlocProvider.value(
            value: existingBloc,
            child: _buildContent(),
          )
        : BlocProvider(
            create: (_) => HomeBloc(homeRepository: HomeRepository()),
            child: _buildContent(),
          );
  }

  Widget _buildContent() {
    return BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is CancelBookingSuccessState) {
            // Close all bottom sheets (both BookCancel and BookingDetailBottomSheet)
            // First close BookCancel, then close BookingDetailBottomSheet
            Navigator.pop(context); // Close BookCancel
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Close BookingDetailBottomSheet if it exists
            }
            if (widget.parentBloc != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final companyId = HelperFunctions.getCompanyId() ?? 0;
                if (companyId > 0) {
                  widget.parentBloc!.add(GetOwnerBookingsEvent(
                    page: 1,
                    limit: 10,
                    companyId: companyId,
                  ));
                }
              });
            }
          } else if (state is HomeErrorState) {
            CenterDialog.errorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is CancelBookingLoadingState;
          return Container(
            padding: EdgeInsets.all(16.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                topLeft: Radius.circular(16.r),
              ),
            ),
            child: haveProblem
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColor.greyE5,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "cancelBookingReason".tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      for (int i = 0; i < cancelReasons.length; i++)
                        GestureDetector(
                          onTap: () {
                            selectText = cancelReasons[i];
                            textField = false;
                            if (selectText == cancelReasons.last) {
                              textField = true;
                            }
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(width: 1.w, color: AppColor.greyE5),
                            ),
                            child: Row(
                              children: [
                                AppSvgAsset(
                                  icons[i],
                                  width: 20.w,
                                  fit: BoxFit.cover,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    cancelReasons[i].tr(),
                                    style: TextStyle(
                                      color: selectText == cancelReasons[i]
                                          ? Colors.black
                                          : AppColor.c777A76,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                selectText == cancelReasons[i]
                                    ? Container(
                                        width: 17.w,
                                        height: 17.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100.r),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              AppColor.yellowFFC,
                                              AppColor.yellow8E,
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                              color: AppColor.white,
                                              borderRadius: BorderRadius.circular(100.r),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 17.w,
                                        height: 17.w,
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.circular(100.r),
                                          border: Border.all(
                                            width: 1.w,
                                            color: AppColor.greyE5,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      if (textField)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${"giveFeedback".tr()} ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "(${"optional".tr()})",
                                    style: TextStyle(
                                      color: AppColor.cA7AAA7,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextField(
                              cursorColor: Colors.grey,
                              onChanged: (v) {
                                setState(() {});
                              },
                              controller: controller,
                              maxLines: 4,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                hintText: "writeComments".tr(),
                                hintStyle: TextStyle(
                                  color: AppColor.grey58,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: AppColor.cD9D9D9,
                                    width: 0.5.w,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide(
                                    color: AppColor.cD9D9D9,
                                    width: 0.5.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                          ],
                        ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: "no".tr(),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              margin: EdgeInsets.zero,
                              backColor: AppColor.white,
                              isGradient: true,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: AppButton(
                              text: "yes".tr(),
                              isGradient: false,
                              txtColor: Colors.black,
                              onTap: () {
                                if (selectText.isNotEmpty && !isLoading) {
                                  final note = _getNote();
                                  context.read<HomeBloc>().add(
                                    CancelBookingEvent(
                                      bookingId: widget.bookingId,
                                      note: note,
                                    ),
                                  );
                                }
                              },
                              loading: isLoading,
                              margin: EdgeInsets.zero,
                              backColor: AppColor.white,
                              border: Border.all(width: 1.w, color: AppColor.cD6D8D6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColor.greyE5,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        height: 120.h,
                        width: 120.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.redFF,
                        ),
                        child: Center(
                          child: AppSvgAsset(
                            AppIcons.trash,
                            height: 48.h,
                            width: 48.h,
                            color: AppColor.redED,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "cancelBookingQuestion".tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "cancelBookingDescription".tr(),
                        style: TextStyle(
                          color: AppColor.grey58,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: "no".tr(),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              margin: EdgeInsets.zero,
                              backColor: AppColor.white,
                              isGradient: true,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: AppButton(
                              text: "yes".tr(),
                              isGradient: false,
                              txtColor: Colors.black,
                              onTap: () {
                                if (!isLoading) {
                                  // Cancel directly without asking for reason
                                  context.read<HomeBloc>().add(
                                    CancelBookingEvent(
                                      bookingId: widget.bookingId,
                                      note: "", // Empty note, cancel directly
                                    ),
                                  );
                                }
                              },
                              loading: isLoading,
                              margin: EdgeInsets.zero,
                              backColor: AppColor.white,
                              border: Border.all(width: 1.w, color: AppColor.cD6D8D6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
          );
        },
      );
  }
}

List<String> cancelReasons = [
  "changeTime",
  "bookAnotherPlace",
  "plansChanged",
  "menuNotSuitable",
  "priceNotSuitable",
  "otherReason",
];

List<String> icons = [
  AppIcons.hour,
  AppIcons.building,
  AppIcons.copy,
  AppIcons.refresh,
  AppIcons.money,
  AppIcons.pen,
];
