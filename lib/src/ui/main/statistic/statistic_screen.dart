import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/statistic/statistic_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/statistic/statistic_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  StatisticItemData? data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    BlocProvider.of<HomeBloc>(
      context,
    ).add(GetStatisticEvent(date: DateTime.now(), period: "daily"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetStatisticSuccessState) {
          data = state.data;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: Column(
            children: [
              TopBarWidget(),
              if(state is GetStatisticSuccessState)
              data == null
                  ? Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppColor.black,
                      ),
                    )
                  : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      StatisticItemWidget(
                        icon: AppIcons.coins,
                        title: "Kunlik Tushum",
                        desc: "${data!.totalRevenue.priceFormat()} UZS",
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.users,
                        title: "Kelayotgan mijozlar",
                        desc: data!.totalCustomers.toString(),
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.shop,
                        title: "Band joylar",
                        desc: "0",
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.shop,
                        title: "Bo’sh joylar",
                        desc: "0",
                      ),
                      SizedBox(height: 12.h),
                      if( data!.newCustomers.isNotEmpty )
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColor.white,
                            border: Border.all(
                              width: 1.h,
                              color: AppColor.greyE5,
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40.h,
                                      width: 40.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        color: AppColor.greyFA,
                                        border: Border.all(
                                          width: 1.h,
                                          color: AppColor.greyE5,
                                        ),
                                      ),
                                      child: Center(
                                        child: AppSvgAsset(
                                          AppIcons.users,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Text(
                                        "Yange Mijozlar",
                                        style: AppTextStyle.f500s16
                                            .copyWith(
                                          color: AppColor.grey58,
                                        ),
                                      ),
                                    ),
                                    AppIconButton(
                                      height: 40.h,
                                      width: 40.h,
                                      icon: AppIcons.filter,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                color: AppColor.greyFA,
                                child: Row(
                                  children: [
                                    Text(
                                      "Full Name",
                                      style: AppTextStyle.f500s14.copyWith(
                                        color: AppColor.grey58,
                                      ),
                                    ),
                                    SizedBox(width: 64.w),
                                    Text(
                                      "Phone Number",
                                      style: AppTextStyle.f500s14.copyWith(
                                        color: AppColor.grey58,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              for (
                              int i = 0;
                              i < data!.newCustomers.length;
                              i++
                              )
                                Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 16.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data!.newCustomers[i].fullName,
                                        maxLines: 1,

                                        style: AppTextStyle.f500s14,
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "99 130 30 35",
                                          style: AppTextStyle.f500s14
                                              .copyWith(
                                            decoration: TextDecoration
                                                .underline,
                                          ),
                                        ),
                                      ),
                                      AppIconButton(
                                        icon: AppIcons.right,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              if(state is HomeErrorState) Expanded(
                child : Center(
                  child : EmptyWidget(text: state.message)
                )
              )
            ],
          ),
        );
      },
    );
  }
}
