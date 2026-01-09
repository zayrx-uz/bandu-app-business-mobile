import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/place/place_business_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/place/screen/add_place_screen.dart';
import 'package:bandu_business/src/ui/main/place/screen/edit_people_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
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
            data = state.data;
          }
        },
        builder: (context, state) {
          if (state is GetPlaceBusinessLoadingState && data == null) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppColor.black,
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
                      child: Center(
                        child: EmptyWidget(
                          text: "noPlacesAvailable".tr(),
                          icon: AppIcons.chair,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      floatingActionButton: CupertinoButton(
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
      ),
    );
  }

  Widget item(PlaceBusinessItemData item) {
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
            AppSvgAsset(AppIcons.placeSelect),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
