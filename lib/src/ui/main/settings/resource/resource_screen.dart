import 'dart:io';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart'
    hide Image;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/ui/main/settings/resource/create_resource_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/settings/resource/resource_widget.dart';
import 'package:bandu_business/src/widget/main/settings/resource/resource_widget_grid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourceScreen extends StatefulWidget {
  const ResourceScreen({super.key});

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  ResourceModel? lastResourceData;
  bool l = false;

  Future<void> getData() async {
    BlocProvider.of<HomeBloc>(context).add(GetResourceEvent(id: 0));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopBarWidget(text: "resource".tr(), isAppName: false, isBack: true),
          Expanded(
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is GetResourceSuccessState) {
                  lastResourceData = state.data;
                }
                if (state is DeleteResourceSuccessState || state is EditResourceSuccessState) {
                  getData();
                }
              },
              builder: (context, state) {
                ResourceModel? displayData = (state is GetResourceSuccessState)
                    ? state.data
                    : lastResourceData;

                if (state is GetResourceLoadingState &&
                    lastResourceData == null) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (displayData != null) {
                  if (displayData.data.isEmpty) {
                    return RefreshIndicator(
                      color: AppColor.yellowFFC,
                      onRefresh: getData,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 100.h),
                          EmptyWidget(
                            text: "noResourcesAvailable".tr(),
                            icon: AppIcons.resourceCub,
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColor.yellowFFC,
                    onRefresh: getData,
                    child: Column(
                      children: [
                        SizedBox(height: 18.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "resources".tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  l = !l;
                                  setState(() {});
                                },
                                child: SvgPicture.asset(
                                  !l
                                      ? AppIcons.resourceCub
                                      : AppIcons.linesIcon,
                                  width: 24.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        !l
                            ? Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  itemCount: displayData.data.length,
                                  itemBuilder: (context, index) {
                                    return ResourceWidget(
                                      data: displayData.data[index],
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.w,
                                  padding: EdgeInsets.all( 16.w),
                                  childAspectRatio: 0.8,
                                  children: [
                                 ...List.generate(displayData.data.length, (index){
                                   return ResourceWidgetGrid(data: displayData.data[index]);
                                 })
                                  ],
                                ),
                              ),
                      ],
                    ),
                  );
                }

                if (state is HomeErrorState) {
                  return RefreshIndicator(
                    onRefresh: getData,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 100.h),
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                AppImages.box,
                                width: 200.w,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                state.message,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CacheService.getString("user_role") == "BUSINESS_OWNER" ||  CacheService.getString("user_role") == "MANAGER"  ? CupertinoButton(
        onPressed: () async {
          final bloc = BlocProvider.of<HomeBloc>(context);
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: bloc,
                child: const CreateResourceScreen(),
              ),
            ),
          );
          if (result == true && mounted) {
            getData();
          }
        },
        padding: EdgeInsets.zero,
        child: Container(
          height: 48.h,
          width: 48.h,
          margin: EdgeInsets.only(bottom: Platform.isAndroid ? 52.h : 28.h),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColor.buttonGradient,
          ),
          child: Center(
            child: AppSvgAsset(AppIcons.plus, color: AppColor.white),
          ),
        ),
      ) : SizedBox(),
    );
  }
}
