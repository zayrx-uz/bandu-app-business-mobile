import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_places_empty_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/place/screen/edit_people_screen.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmptyPlacesScreen extends StatefulWidget {
  const EmptyPlacesScreen({super.key});

  @override
  State<EmptyPlacesScreen> createState() => _EmptyPlacesScreenState();
}

class _EmptyPlacesScreenState extends State<EmptyPlacesScreen> {
  DashboardPlacesEmptyData? data;

  @override
  void initState() {
    super.initState();
    getData();
    _setupRxBus();
  }

  void _setupRxBus() {
    RxBus.register(tag: "PLACE_ICON_UPDATED").listen((d) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void getData() {
    final companyId = HelperFunctions.getCompanyId();
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final clientDateTime = now.toIso8601String();
    
    BlocProvider.of<HomeBloc>(context).add(
      GetEmptyPlacesEvent(
        companyId: companyId,
        date: formattedDate,
        clientDateTime: clientDateTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetEmptyPlacesSuccessState) {
            data = state.data;
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is GetEmptyPlacesLoadingState && data == null) {
            return Column(
              children: [
                TopBarWidget(),
                Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: AppColor.black,
                    ),
                  ),
                ),
              ],
            );
          }
          
          if (state is HomeErrorState && data == null) {
            return Column(
              children: [
                TopBarWidget(
                  isBack: true,
                ),
                Expanded(
                  child: Center(
                    child: EmptyWidget(text: state.message),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarWidget(isBack: true,),
              if (data != null && _hasPlaces(data!))
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < data!.groups.length; i++)
                              if (data!.groups[i].places.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // if (i > 0) SizedBox(height: 24.h),
                                    // Text(
                                    //   data!.groups[i].categoryName,
                                    //   style: AppTextStyle.f600s16,
                                    // ),
                                    // SizedBox(height: 12.h),
                                    Wrap(
                                      spacing: 16.w,
                                      runSpacing: 16.h,
                                      children: [
                                        for (int j = 0; j < data!.groups[i].places.length; j++)
                                          item(data!.groups[i].places[j]),
                                      ],
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (data != null && !_hasPlaces(data!))
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
                          SizedBox(height: 130.h),
                          Image.asset(
                            AppImages.empty,
                            width: 200.w,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "noEmptyPlacesAvailable".tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "allPlacesAreOccupied".tr(),
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
    );
  }

  bool _hasPlaces(DashboardPlacesEmptyData data) {
    for (var group in data.groups) {
      if (group.places.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Widget item(DashboardEmptyPlace place) {
    final placeIconUrl = CacheService.getPlaceIcon();
    
    return CupertinoButton(
      onPressed: () {
        CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (_) => HomeBloc(homeRepository: HomeRepository()),
              child: EditPlaceScreen(
                name: place.name,
                id: place.id,
                employeeIds: null,
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
                place.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.f400s12,
              ),
            ),
            SizedBox(height: 6.h),
            Builder(
              builder: (context) {
                if (placeIconUrl.isNotEmpty) {
                  if (placeIconUrl.endsWith('.svg')) {
                    return SvgPicture.network(
                      placeIconUrl,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => Container(
                        width: 40.w,
                        height: 40.w,
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  } else {
                    return Image.network(
                      placeIconUrl,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 40.w,
                          height: 40.w,
                          child: CupertinoActivityIndicator(),
                        );
                      },
                    );
                  }
                }
                
                final cachedIcon = CacheService.getCategoryIcon();
                final imagePath = cachedIcon.isNotEmpty 
                    ? cachedIcon 
                    : HelperFunctions.getCategoryIconByIkpuCode(CacheService.getCategoryIkpuCode());
                
                return imagePath.contains('assets/images/')
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
                      );
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
