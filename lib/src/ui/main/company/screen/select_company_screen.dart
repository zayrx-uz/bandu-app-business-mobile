import 'dart:io';

import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/main/home/company_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/company/create_company_screen.dart';
import 'package:bandu_business/src/ui/main/main_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCompanyScreen extends StatefulWidget {
  final bool canPop;

  const SelectCompanyScreen({super.key, this.canPop = false});

  @override
  State<SelectCompanyScreen> createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  int selectedId = -1;
  List<CompanyData>? data;

  @override
  void initState() {
    getData();
    selectedId = HelperFunctions.getCompanyId();
    super.initState();
  }

  void getData() {
    BlocProvider.of<HomeBloc>(context).add(GetCompanyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetCompanySuccessState) {
          data = state.data.data;
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: widget.canPop,
          child: Scaffold(
            backgroundColor: AppColor.white,
            body: Column(
              children: [
                TopBarWidget(
                  isAppName: false,
                  text: "Select company",
                  isBack: widget.canPop,
                ),
                if (data == null)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppColor.black,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: data!.length,
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      itemBuilder: (_, index) {
                        return CupertinoButton(
                          onPressed: () {
                            selectedId = data?[index].id ?? -1;
                            setState(() {});
                          },
                          padding: EdgeInsets.zero,
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: 12.h,
                              left: 16.w,
                              right: 16.w,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColor.white,
                              border: Border.all(
                                width: 1.h,
                                color: AppColor.greyE5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data?[index].name ?? '',
                                    style: AppTextStyle.f500s16,
                                  ),
                                ),
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: selectedId == data![index].id
                                          ? 4.h
                                          : 1.h,
                                      color: selectedId == data![index].id
                                          ? AppColor.yellowFFC
                                          : AppColor.greyF4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                SizedBox(height: 12.h),
                AppButton(
                  onTap: () {
                    print(selectedId);
                    if (selectedId != -1) {
                      CacheService.saveInt("select_company", selectedId);
                      Navigator.popUntil(context, (route) => route.isFirst);
                      AppService.replacePage(context, MainScreen());
                    }
                  },
                  text: "Selected",
                ),
                SizedBox(height: 24.h),
              ],
            ),
            floatingActionButton: CupertinoButton(
              onPressed: () {
                AppService.changePage(
                  context,
                  BlocProvider(
                    create: (_) => HomeBloc(homeRepository: HomeRepository()),
                    child: const CreateCompanyScreen(),
                  ),
                );
              },
              padding: EdgeInsets.zero,
              child: Container(
                height: 48.h,
                width: 48.h,
                margin: EdgeInsets.only(
                  bottom: Platform.isAndroid ? 72.h : 48.h,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColor.buttonGradient,
                ),
                child: Center(
                  child: AppSvgAsset(AppIcons.plus, color: AppColor.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
