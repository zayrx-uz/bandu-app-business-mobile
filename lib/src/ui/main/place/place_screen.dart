import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/main/place/place_business_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/place/screen/add_place_screen.dart';
import 'package:bandu_business/src/ui/main/place/screen/edit_people_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  List<PlaceBusinessItemData>? data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    BlocProvider.of<HomeBloc>(context).add(
      GetPlaceBusinessEvent(companyId: HelperFunctions.getCompanyId() ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetPlaceBusinessSuccessState) {
            setState(() {
              data = state.data;
            });
          }
        },
        builder: (context, state) {
          if (state is GetPlaceBusinessLoadingState && data == null) {
            return Center(
              child: CupertinoActivityIndicator(
                color: AppColor.black,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarWidget(),
              if (data != null && data!.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getData();
                      await Future.delayed(Duration(milliseconds: 500));
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Wrap(
                        spacing: 16.w,
                        runSpacing: 16.h,
                        children: [
                          for (int i = 0; i < data!.length; i++) item(data![i]),
                        ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (data != null && data!.isEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getData();
                      await Future.delayed(Duration(milliseconds: 500));
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 130.h,),
                          Image.asset(
                            AppImages.empty,
                            width: 200.w,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "noPlacesAvailable".tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "addPlace".tr(),
                            style: TextStyle(
                              color: AppColor.greyA7,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      floatingActionButton: CacheService.getString("user_role") == "BUSINESS_OWNER" ||  CacheService.getString("user_role") == "MANAGER"  ? CupertinoButton(
        onPressed: () {
          CupertinoScaffold.showCupertinoModalBottomSheet(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: const AddPlaceScreen(),
              );
            },
          ).then((on) {
            getData();
          });
        },
        padding: EdgeInsets.zero,
        child: Container(
          height: 48.h,
          width: 48.h,
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

  Widget item(PlaceBusinessItemData item) {
    final ikpuCode = CacheService.getCategoryIkpuCode();
    final imagePath = HelperFunctions.getCategoryIconByIkpuCode(ikpuCode);
    
    return CupertinoButton(
      onPressed: () {
        CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (_) => HomeBloc(homeRepository: HomeRepository()),
              child: EditPlaceScreen(
                name: item.name,
                id: item.id,
                number: item.capacity,
              ),
            );
          },
        ).then((on) {
          getData();
        });
      },
      padding: EdgeInsets.zero,
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 1.h, color: AppColor.greyE5),
          color: AppColor.white,
        ),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: AppColor.greyF4,
              ),
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.f400s12,
              ),
            ),
            SizedBox(height: 6.h),
            imagePath.contains('assets/images/')
                ? Image.asset(
                    imagePath,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                  )
                : AppSvgAsset(
                    imagePath,
                    width: 40.w,
                    height: 40.w,
                  ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
