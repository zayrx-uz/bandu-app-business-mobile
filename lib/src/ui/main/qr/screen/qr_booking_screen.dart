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
            "Booking confirmed successfully",
            () {
              Navigator.pop(context);
            },
          );
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
                        child: Text("Book Info", style: AppTextStyle.f600s18),
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
                        title: "Company",
                        data: data!.company.name,
                      ),
                      ReceiptItemWidget(
                        title: "Booking Time",
                        data:
                            "${data!.bookingTime.toHHMM()} ${data!.bookingTime.toDDMMYYY()}",
                      ),
                      for (int i = 0; i < data!.places.length; i++)
                        ReceiptItemWidget(
                          title: "Place ${i + 1}",
                          data: data!.places[i].name,
                        ),
                      ReceiptItemWidget(
                        title: "Number of People",
                        data: data!.numbersOfPeople.toString(),
                      ),
                      ReceiptItemWidget(
                        title: "Total Price",
                        data: data!.totalPrice.priceFormat(),
                      ),
                      ReceiptItemWidget(
                        title: "Status",
                        data: data!.status.capitalizeFirstLetter(),
                        dataColor: data!.status == "pending"
                            ? AppColor.yellowFF
                            : AppColor.green34,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                if (data!.status == "pending")
                  AppButton(
                    onTap: () {
                      BlocProvider.of<HomeBloc>(
                        context,
                      ).add(ConfirmBookEvent(bookId: data!.id));
                    },
                    loading: loading,
                    text: "Confirm booking",
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
