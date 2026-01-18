import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
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
      listener: (context, state) {
        if (state is CheckAlicePaymentLoadingState) {
          setState(() {
            _isChecking = true;
          });
        } else if (state is CheckAlicePaymentSuccessState) {
          setState(() {
            _isChecking = false;
          });
          if (state.isPaid) {
            CenterDialog.successDialog(
              context,
              state.message.isNotEmpty
                  ? state.message
                  : "paymentVerifiedSuccessfully".tr(),
              () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          } else {
            CenterDialog.errorDialog(context, state.message);
          }
        } else if (state is HomeErrorState) {
          setState(() {
            _isChecking = false;
          });
          CenterDialog.errorDialog(context, state.message);
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
