import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/device_helper/device_helper.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/provider/auth/auth_provider.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CenterDialog {
  static void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider(
          create: (_) => AuthBloc(authRepository: AuthRepository()),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is LogoutSuccessState) {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
                AppService.replacePage(context, OnboardScreen());
              } else if (state is AuthErrorState) {
                Navigator.of(dialogContext).pop();
                CacheService.clear();
                Navigator.of(context).popUntil((route) => route.isFirst);
                AppService.replacePage(context, OnboardScreen());
              }
            },
            builder: (context, state) {
              final isLoading = state is LogoutLoadingState;
              return PopScope(
                canPop: !isLoading,
                child: CupertinoAlertDialog(
                  title: Text(
                    "logOut".tr(),
                    style: TextStyle(
                      fontSize: isTablet(context) ? 12.sp : 16.sp,
                    ),
                  ),
                  content: Column(
                    children: [
                      if (isLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: CupertinoActivityIndicator(
                            color: AppColor.black,
                          ),
                        )
                      else
                        Text(
                          "areYouSureLogOut".tr(),
                          style: TextStyle(
                            fontSize: isTablet(context) ? 8.sp : 12.sp,
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    if (!isLoading)
                      CupertinoButton(
                        child: Text(
                          "cancel".tr(),
                          style: AppTextStyle.f600s16.copyWith(
                            color: AppColor.blue00,
                            fontSize: isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    CupertinoButton(
                      onPressed: isLoading
                          ? null
                          : () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      child: Text(
                        "logOut".tr(),
                        style: AppTextStyle.f600s16.copyWith(
                          color: AppColor.red00,
                          fontSize: isTablet(context) ? 12.sp : 16.sp,
                        ),
                      ),

                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static void deleteAccountDialog(BuildContext context) {
    final authProvider = AuthProvider();
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoAlertDialog(
              title: Text(
                "deleteAccount".tr(),
                style: TextStyle(
                  fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              content: isLoading
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: CupertinoActivityIndicator(),
                    )
                  : Text(
                      "areYouSureDeleteAccountPermanent".tr(),
                      style: TextStyle(
                        fontSize: DeviceHelper.isTablet(context) ? 8.sp : 12.sp,
                      ),
                    ),
              actions: [
                if (!isLoading)
                  CupertinoButton(
                    child: Text(
                      "cancel".tr(),
                      style: AppTextStyle.f600s16.copyWith(
                        color: AppColor.blue00,
                        fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                CupertinoButton(
                  child: isLoading
                      ? CupertinoActivityIndicator()
                      : Text(
                          "delete".tr(),
                          style: AppTextStyle.f600s16.copyWith(
                            color: AppColor.red00,
                            fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          final result = await authProvider.deleteAccount();
                          if (context.mounted) {
                            if (result.isSuccess) {
                              Navigator.of(context).pop();
                              CacheService.clear();
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              AppService.replacePage(context, OnboardScreen());
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                              errorDialog(
                                context,
                                HelperFunctions.errorText(result.result),
                              );
                            }
                          }
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }


  static void deleteResourceDialog(BuildContext context , {required String name , required int id , required VoidCallback onTapDelete}) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: homeBloc,
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is DeleteResourceSuccessState && state.resourceId == id) {
                Navigator.of(context).pop();
              }
              if (state is HomeErrorState) {
                Navigator.of(context).pop();
                errorDialog(context, state.message);
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                final isLoading = state is DeleteResourceLoadingState && state.resourceId == id;
                return CupertinoAlertDialog(
                  title: Text(
                    "deleteResource".tr(),
                    style: TextStyle(
                      fontSize: isTablet(context) ? 12.sp : 16.sp,
                    ),
                  ),
                  content: isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: CupertinoActivityIndicator(),
                        )
                      : Text(
                          "${"deleteResourceConfirm".tr()} ($name)?",
                          style: TextStyle(
                            fontSize: isTablet(context) ? 8.sp : 12.sp,
                          ),
                        ),
                  actions: [
                    if (!isLoading)
                      CupertinoButton(
                        child: Text(
                          "cancel".tr(),
                          style: AppTextStyle.f600s16.copyWith(
                            color: AppColor.blue00,
                            fontSize: isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    CupertinoButton(
                      child: isLoading
                          ? CupertinoActivityIndicator()
                          : Text(
                              "delete".tr(),
                              style: AppTextStyle.f600s16.copyWith(
                                color: AppColor.red00,
                                fontSize: isTablet(context) ? 12.sp : 16.sp,
                              ),
                            ),
                      onPressed: isLoading ? null : () {
                        onTapDelete();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static void deleteEmployeeDialog(
    BuildContext context, {
    required int employeeId,
    required Function() onDelete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(
            "deleteEmployee".tr(),
            style: TextStyle(
              fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          content: Text(
            "areYouSureDeleteEmployee".tr(),
            style: TextStyle(
              fontSize: DeviceHelper.isTablet(context) ? 8.sp : 12.sp,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                "cancel".tr(),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.blue00,
                  fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "delete".tr(),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.red00,
                  fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }

  static void soonDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("soon".tr() , style: TextStyle(
            fontSize : isTablet(context) ? 12.sp : 16.sp
          ),),
          content: Text(text , style: TextStyle(
             fontSize:  isTablet(context) ? 8.sp : 12.sp
          ),),
          actions: [
            CupertinoButton(
              child: Text(
                "ok".tr(),
                style: AppTextStyle.f600s16.copyWith(color: AppColor.blue00 , fontSize : isTablet(context) ? 12.sp : 16.sp),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void showCustomRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        double rating = 0;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text("rateOurApp".tr()),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("pleaseRateExperience".tr()),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () => setState(() => rating = i + 1.0),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("submit".tr()),
            ),
          ],
        );
      },
    );
  }

  static void confirmBookingDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "confirmBooking".tr(),
            style: TextStyle(
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          content: Text(
            "areYouSureConfirmBooking".tr(),
            style: TextStyle(
              fontSize: isTablet(context) ? 8.sp : 12.sp,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                "cancel".tr(),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.blue00,
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "confirm".tr(),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.black,
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  static void errorDialog(BuildContext context, String text) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) {
        return EasyLocalization(
          supportedLocales: const [Locale('en', 'EN'), Locale('ru', 'RU'), Locale('uz', 'UZ')],
          path: 'assets/translations',
          startLocale: EasyLocalization.of(context)?.locale ?? const Locale('ru', 'RU'),
          fallbackLocale: const Locale('ru', 'RU'),
          child: Builder(
            builder: (localizedContext) {
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color : Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.r),
                          topLeft: Radius.circular(16.r)
                      )
                  ),
                  child : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 12.h,),
                      Container(
                        width: 56.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                            color : AppColor.cE5E7E5,
                            borderRadius: BorderRadius.circular(100.r)
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Image.asset(AppImages.manVectorImage , width: 200.w,fit : BoxFit.cover),
                      SizedBox(height: 10.h,),
                      Text("error".tr() , style: TextStyle(
                          color : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp
                      ),),
                      SizedBox(height: 8.h,),
                      Text(text , style: TextStyle(
                          color : AppColor.c6C6C6C,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h,),
                      AppButton(
                        onTap: (){
                          Navigator.pop(context);
                        } ,
                        isGradient: false,
                        txtColor: Colors.black,
                        text: "goBack".tr(),backColor: Colors.white,border: Border.all(
                          width: 1.w,
                          color : AppColor.cE5E7E5
                      ),),
                      SizedBox(height: 40.h,),
                    ],
                  )
              );
            },
          ),
        );
      },
    );
  }

  static void successDialog(
    BuildContext context,
    String text,
    Function() onTap,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "success".tr(),
            style: AppTextStyle.f600s16.copyWith(color: AppColor.green34),
          ),
          content: Text(text, style: AppTextStyle.f400s16),
          actions: [
            CupertinoButton(
              child: Text(
                "ok".tr(),
                style: AppTextStyle.f600s16.copyWith(color: AppColor.blue00),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    ).then((d) {
      onTap();
    });
  }

  static void confirmPaymentDialog(
    BuildContext context, {
    required int paymentId,
    required VoidCallback onConfirm,
  }) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: homeBloc,
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is ConfirmPaymentSuccessState && state.paymentId == paymentId) {
                Navigator.of(context).pop();
              }
              if (state is HomeErrorState) {
                Navigator.of(context).pop();
                errorDialog(context, state.message);
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                final isLoading = state is ConfirmPaymentLoadingState && state.paymentId == paymentId;
                return CupertinoAlertDialog(
                  title: Text(
                    "confirmPayment".tr(),
                    style: TextStyle(
                      fontSize: isTablet(context) ? 12.sp : 16.sp,
                    ),
                  ),
                  content: isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: CupertinoActivityIndicator(),
                        )
                      : Text(
                          "areYouSureConfirmPayment".tr(),
                          style: TextStyle(
                            fontSize: isTablet(context) ? 8.sp : 12.sp,
                          ),
                        ),
                  actions: [
                      CupertinoButton(
                        onPressed: !isLoading ? () {
                          Navigator.of(context).pop();
                        } : (){},
                        child: Text(
                          "cancel".tr(),
                          style: AppTextStyle.f600s16.copyWith(
                            color: AppColor.blue00,
                            fontSize: isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),

                      ),
                    CupertinoButton(
                      onPressed: isLoading ? null : () {
                        onConfirm();
                      },
                      child: Text(
                              "confirm".tr(),
                              style: AppTextStyle.f600s16.copyWith(
                                color: AppColor.black,
                                fontSize: isTablet(context) ? 12.sp : 16.sp,
                              ),
                            ),

                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static void completeBookingDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "completeBooking".tr(),
            style: TextStyle(
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          content: Text(
            "areYouSureCompleteBooking".tr(),
            style: TextStyle(
              fontSize: isTablet(context) ? 8.sp : 12.sp,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                "cancel".tr(),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.blue00,
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "confirm".tr(),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.black,
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}
