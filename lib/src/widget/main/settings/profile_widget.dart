import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/auth/login_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/settings/edit/edit_profile_screen.dart';
import 'package:bandu_business/src/ui/main/settings/notification_screen/notification_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/app/shimmer_widget.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  String _formatRole(String role) {
    return role.replaceAll('_', ' ').toLowerCase().split(' ').map((word) {
      return word.isEmpty
          ? ''
          : word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        bool isLoading = state is GetMeLoadingState;
        LoginModel? userData;
        
        if (state is GetMeSuccessState) {
          userData = state.data;
        }

        return Container(
          height: 336.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.profileBack),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    TopAppName(color: AppColor.white),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        AppService.changePage(context, NotificationScreen());
                      },
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.notificationIcon,
                            width: 16.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 92.h,
                width: 92.h,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        height: 80.h,
                        width: 80.h,
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColor.white.withValues(alpha: 0),
                              AppColor.white,
                            ],
                          ),
                        ),
                        child: Center(
                          child: isLoading
                              ? ShimmerWidget(
                                  height: 80.h,
                                  width: 80.h,
                                  borderRadius: 16.r,
                                )
                              : CustomNetworkImage(
                                  imageUrl: userData?.data.user.profilePicture ??
                                      CacheService.getString("image"),
                                  height: 80.h,
                                  width: 80.h,
                                  borderRadius: 16.r,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 12.w,
                      left: 0,
                      child: Center(
                        child: CupertinoButton(
                          onPressed: () {
                            AppService.changePage(
                              context,
                              BlocProvider(
                                create: (_) =>
                                    HomeBloc(homeRepository: HomeRepository()),
                                child: EditProfileScreen(),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          child: Container(
                            height: 24.h,
                            width: 24.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: AppColor.white,
                            ),
                            child: Center(child: AppSvgAsset(AppIcons.edit)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              isLoading
                  ? ShimmerWidget(
                      width: 150.w,
                      height: 20.h,
                      borderRadius: 4.r,
                    )
                  : Text(
                      userData?.data.user.fullName ??
                          CacheService.getString("full_name"),
                      style: AppTextStyle.f600s20.copyWith(color: AppColor.white),
                    ),
              SizedBox(height: 4.h),
              isLoading
                  ? ShimmerWidget(
                      width: 120.w,
                      height: 14.h,
                      borderRadius: 4.r,
                    )
                  : Text(
                      userData != null
                          ? "+${userData.data.phoneNumber}"
                          : "+${CacheService.getString("phone")}",
                      style: AppTextStyle.f400s14.copyWith(color: AppColor.white),
                    ),
              if (userData != null && userData.data.user.role.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  _formatRole(userData.data.user.role),
                  style: AppTextStyle.f400s12.copyWith(color: AppColor.white.withValues(alpha: 0.8)),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
