import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/qr/book_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/qr/screen/receipt_item_widget.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/widget/main/qr/alice_checker_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class QrBookingScreen extends StatefulWidget {
  final String dt;

  const QrBookingScreen({super.key, required this.dt});

  @override
  State<QrBookingScreen> createState() => _QrBookingScreenState();
}

class _QrBookingScreenState extends State<QrBookingScreen> {
  BookingData? data;

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(GetQrBookCodeEvent(url: widget.dt));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetQRBookCodeSuccessState) {
          data = state.data;
        } else if (state is HomeErrorState) {
          CenterDialog.errorDialog(context, state.message);
        } else if (state is ConfirmBookSuccessState) {
          CenterDialog.successDialog(
            context,
            "bookingConfirmedSuccessfully".tr(),
            () {
              Navigator.pop(context);
            },
          );
        } else if (state is CheckAlicePaymentSuccessState) {
          if (state.isPaid) {
            CenterDialog.successDialog(
              context,
              state.message.isNotEmpty
                  ? state.message
                  : "paymentVerifiedSuccessfully".tr(),
              () {
                Navigator.pop(context);
              },
            );
          }
        }
      },
      builder: (context, state) {
        bool loading = state is ConfirmBookLoadingState;
        if (data == null) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: AppColor.black,
            ),
          );
        }
        return Material(
          child: Container(
            color: AppColor.white,
            child: Column(
              children: [
                SizedBox(height: 12.h),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("bookInfo".tr(), style: AppTextStyle.f600s18),
                      ),
                      AppIconButton(
                        icon: AppIcons.close,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 0.5.h,
                  width: MediaQuery.of(context).size.width,
                  color: AppColor.greyE5,
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Column(
                    children: [
                      ReceiptItemWidget(
                        title: "company".tr(),
                        data: data!.company.name,
                      ),
                      ReceiptItemWidget(
                        title: "bookingTime".tr(),
                        data:
                            "${data!.bookingTime.toHHMM()} ${data!.bookingTime.toDDMMYYY()}",
                      ),
                      for (int i = 0; i < data!.places.length; i++)
                        ReceiptItemWidget(
                          title: "${"place".tr()} ${i + 1}",
                          data: data!.places[i].name,
                        ),
                      ReceiptItemWidget(
                        title: "numberOfPeople".tr(),
                        data: data!.numbersOfPeople.toString(),
                      ),
                      ReceiptItemWidget(
                        title: "totalPrice".tr(),
                        data: data!.totalPrice.priceFormat(),
                      ),
                      ReceiptItemWidget(
                        title: "status".tr(),
                        data: data!.status.getLocalizedStatus(),
                        dataColor: data!.status.toLowerCase() == "pending"
                            ? AppColor.yellowFF
                            : data!.status.toLowerCase() == "confirmed"
                                ? AppColor.yellow8E
                                : data!.status.toLowerCase() == "canceled" || data!.status.toLowerCase() == "cancelled"
                                    ? AppColor.cE52E4C
                                    : AppColor.green34,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                if (data!.status == "pending")
                  Column(
                    children: [
                      AppButton(
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) => AliceCheckerWidget(
                              bookingId: data!.id,
                            ),
                          );
                        },
                        text: "checkPayment".tr(),
                        backColor: AppColor.blue00,
                        isGradient: false,
                      ),
                      SizedBox(height: 12.h),
                      AppButton(
                        onTap: () {
                          BlocProvider.of<HomeBloc>(
                            context,
                          ).add(ConfirmBookEvent(bookId: data!.id));
                        },
                        loading: loading,
                        text: "confirmBooking".tr(),
                      ),
                    ],
                  ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
