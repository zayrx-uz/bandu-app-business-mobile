import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/api/main/qr/place_model.dart';

class QrDetailScreen extends StatefulWidget {
  final String dt;

  const QrDetailScreen({super.key, required this.dt});

  @override
  State<QrDetailScreen> createState() => _QrDetailScreenState();
}

class _QrDetailScreenState extends State<QrDetailScreen> {
  QrPlaceModel? data;

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(GetQrCodeEvent(url: widget.dt));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetQRCodeSuccessState) {
          data = state.data;
        } else if (state is HomeErrorState) {
          CenterDialog.errorDialog(context, state.message);
        }
      },
      builder: (context, state) {
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
                        child: Text(
                          "detailedInfo".tr(),
                          style: AppTextStyle.f600s18,
                        ),
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
                Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColor.white,
                    border: Border.all(width: 1.h, color: AppColor.greyE5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 56.h,
                            width: 56.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColor.white,
                              border: Border.all(
                                width: 1.h,
                                color: AppColor.greyE5,
                              ),
                            ),
                            child: Center(
                              child: AppSvgAsset(
                                data!.data.isBooked
                                    ? AppIcons.placeOn
                                    : AppIcons.place,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data!.data.place.name,
                                  style: AppTextStyle.f500s20,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  data!.data.company.name,
                                  style: AppTextStyle.f400s16.copyWith(
                                    color: AppColor.grey58,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppIconButton(icon: AppIcons.right, onTap: () {}),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Divider(height: 1, color: AppColor.greyF4),
                      // SizedBox(height: 12.h),
                      // Row(
                      //   children: [
                      //     // CHAP USTUN (Nomi)
                      //     SizedBox(
                      //       width: 90.w,
                      //       child: item("Nomi", data!.places[i].name),
                      //     ),
                      //
                      //     verticalDivider(),
                      //
                      //     // O'RTA USTUN — TO‘LIQ MARKAZDA
                      //     Expanded(
                      //       child: Align(
                      //         alignment: Alignment.center,
                      //         child: item(
                      //           "Vaqti",
                      //           data!.bookingTime.toHHMM(),
                      //         ),
                      //       ),
                      //     ),
                      //
                      //     verticalDivider(),
                      //
                      //     // O‘NG USTUN (Mijoz nomeri)
                      //     SizedBox(
                      //       width: 140.w,
                      //       child: item("Mijoz Nomeri", "(99) 999 99 99"),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget verticalDivider() {
    return Container(height: 46.h, width: 1, color: AppColor.greyF4);
  }

  Widget item(String title, String desc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyle.f400s14.copyWith(color: AppColor.grey77),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          desc,
          maxLines: 1,
          style: AppTextStyle.f500s16,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
