import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AliceCheckerWidget extends StatefulWidget {
  final int bookingId;

  const AliceCheckerWidget({super.key, required this.bookingId});

  @override
  State<AliceCheckerWidget> createState() => _AliceCheckerWidgetState();
}

class _AliceCheckerWidgetState extends State<AliceCheckerWidget> {
  final TextEditingController _transactionIdController = TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    _transactionIdController.dispose();
    super.dispose();
  }

  void _checkPayment() {
    if (_transactionIdController.text.trim().isEmpty) {
      CenterDialog.errorDialog(context, "pleaseEnterTransactionId".tr());
      return;
    }

    BlocProvider.of<HomeBloc>(context).add(
      CheckAlicePaymentEvent(
        transactionId: _transactionIdController.text.trim(),
        bookingId: widget.bookingId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) {
        if (current is CheckAlicePaymentLoadingState) return true;
        if (current is CheckAlicePaymentSuccessState) return true;
        if (current is HomeErrorState) {
          return _isChecking;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CheckAlicePaymentLoadingState) {
          if (mounted) {
            setState(() {
              _isChecking = true;
            });
          }
        } else if (state is CheckAlicePaymentSuccessState) {
          if (mounted) {
            setState(() {
              _isChecking = false;
            });
          }
          Future.delayed(Duration(milliseconds: 50), () {
            if (mounted && context.mounted) {
              if (state.isPaid) {
                AppService.successToast(
                  context,
                  state.message.isNotEmpty
                      ? state.message
                      : "paymentVerifiedSuccessfully".tr(),
                );
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted && context.mounted) {
                    CenterDialog.successDialog(
                      context,
                      state.message.isNotEmpty
                          ? state.message
                          : "paymentVerifiedSuccessfully".tr(),
                      () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  }
                });
              } else {
                AppService.errorToast(
                  context,
                  state.message.isNotEmpty
                      ? state.message
                      : "To'lov tasdiqlanmadi",
                );
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted && context.mounted) {
                    CenterDialog.errorDialog(
                      context,
                      state.message.isNotEmpty
                          ? state.message
                          : "To'lov tasdiqlanmadi",
                    );
                  }
                });
              }
            }
          });
        } else if (state is HomeErrorState) {
          if (_isChecking && mounted) {
            setState(() {
              _isChecking = false;
            });
            Future.delayed(Duration(milliseconds: 50), () {
              if (mounted && context.mounted) {
                AppService.errorToast(context, state.message);
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted && context.mounted) {
                    CenterDialog.errorDialog(context, state.message);
                  }
                });
              }
            });
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "checkPayment".tr(),
              style: AppTextStyle.f600s18,
            ),
            SizedBox(height: 20.h),
            InputWidget(
              controller: _transactionIdController,
              hint: "enterTransactionId".tr(),
              title: "transactionId".tr(),
            ),
            SizedBox(height: 24.h),
            AppButton(
              onTap: _checkPayment,
              loading: _isChecking,
              text: "checkPayment".tr(),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
