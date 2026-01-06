import 'dart:io';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/main/home/company_model.dart';
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
import 'package:flutter_slidable/flutter_slidable.dart';

class SelectCompanyScreen extends StatefulWidget {
  final bool canPop;
  const SelectCompanyScreen({super.key, this.canPop = false});

  @override
  State<SelectCompanyScreen> createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  int selectedId = -1;
  List<CompanyData>? data;
  int? deletingId;
  int? updatingId;

  @override
  void initState() {
    getData();
    selectedId = HelperFunctions.getCompanyId() ?? 0;
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
          setState(() {});
        } else if (state is DeleteCompanyLoadingState) {
          deletingId = state.companyId;
          setState(() {});
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted) {
              final index = data?.indexWhere((e) => e.id == state.companyId);
              if (index != null && index >= 0 && data != null) {
                setState(() {
                  data!.removeAt(index);
                  deletingId = null;
                });
              }
            }
          });
        } else if (state is DeleteCompanySuccessState) {
          deletingId = null;
          // getData();
        } else if (state is UpdateCompanyLoadingState) {
          updatingId = state.companyId;
          setState(() {});
        } else if (state is UpdateCompanySuccessState) {
          updatingId = null;
          AppService.successToast(context, "Company updated");
          getData();
        } else if (state is HomeErrorState) {
          deletingId = null;
          updatingId = null;
          setState(() {});
        }
        if (state is SaveCompanySuccessState) {
          getData();
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
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                else if (data!.isEmpty)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.empty,
                          width: 200.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Malumotlar topilmadi",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Kompaniya qo'shing",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: data!.length,
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      itemBuilder: (_, index) {
                        final companyId = data![index].id;
                        final isDeleting = deletingId == companyId;
                        if (isDeleting) {
                          return const SizedBox.shrink();
                        }
                        return TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset((1 - value) * -50, 0),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
                                  child: Slidable(
                                    key: ValueKey(companyId),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      extentRatio: 0.5,
                                      children: [
                                        CustomSlidableAction(
                                          onPressed: (context) {
                                            if (updatingId == data![index].id ||
                                                deletingId == data![index].id) {
                                              return;
                                            }
                                            final item = data![index];
                                            AppService.changePage(
                                              context,
                                              BlocProvider.value(
                                                value: BlocProvider.of<HomeBloc>(context),
                                                child: CreateCompanyScreen(companyId: item.id),
                                              ),
                                            );
                                          },
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(12.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.redAccent.withValues(alpha: 0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (updatingId == data![index].id)
                                                  SizedBox(
                                                    width: 18.sp,
                                                    height: 18.sp,
                                                    child: const CircularProgressIndicator.adaptive(
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                else ...[
                                                  Icon(Icons.edit, color: Colors.white, size: 22.sp),
                                                  Text(
                                                    "Tahrirlash",
                                                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                        CustomSlidableAction(
                                          onPressed: (context) {
                                            if (deletingId == data![index].id ||
                                                updatingId == data![index].id) {
                                              return;
                                            }
                                            BlocProvider.of<HomeBloc>(context).add(
                                              DeleteCompanyEvent(companyId: data![index].id),
                                            );
                                          },
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.circular(12.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.redAccent.withValues(alpha: 0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (deletingId == data![index].id)
                                                  SizedBox(
                                                    width: 18.sp,
                                                    height: 18.sp,
                                                    child: const CircularProgressIndicator.adaptive(
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                else ...[
                                                  Icon(Icons.delete_outline, color: Colors.white, size: 22.sp),
                                                  Text(
                                                    "O'chirish",
                                                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        selectedId = data![index].id;
                                        setState(() {});
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Container(
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
                                                data![index].name,
                                                style: AppTextStyle.f500s16,
                                              ),
                                            ),
                                            Container(
                                              height: 20.h,
                                              width: 20.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  width: selectedId == data![index].id ? 4.h : 1.h,
                                                  color: selectedId == data![index].id
                                                      ? AppColor.yellowFFC
                                                      : AppColor.greyF4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                if (data != null && data!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: AppButton(
                      onTap: () {
                        if (selectedId != -1) {
                          CacheService.saveInt("select_company", selectedId);
                          Navigator.popUntil(context, (route) => route.isFirst);
                          AppService.replacePage(context, const MainScreen());
                        }
                      },
                      text: "Selected",
                    ),
                  ),
              ],
            ),
            floatingActionButton: CupertinoButton(
              onPressed: () async {
                AppService.changePage(
                  context,
                  BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: const CreateCompanyScreen(),
                  ),
                );
                getData();
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