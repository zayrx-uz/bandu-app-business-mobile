import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
  import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart'
      hide Image;
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/ui/main/settings/resource/edit_resource_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourceWidget extends StatelessWidget {
  const ResourceWidget({super.key, required this.data});

  final Datum data;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          width: double.infinity,
          child: Row(
            children: [
              data.images.isNotEmpty
                  ? CustomNetworkImage(
                      imageUrl: data.images.first.url,
                      borderRadius: 12.r,
                      width: 56.w,
                      height: 56.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.0),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          width: 1.w,
                          color : AppColor.cE5E7E5
                        )
                      ),
                      child: Center(child: SvgPicture.asset(AppIcons.food , width: 32.w,fit : BoxFit.cover))
                    ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                             maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 18.w,),
                        Text(
                          data.resourceCategory != null ? data.resourceCategory!.name : "",
                          style: TextStyle(
                            color: AppColor.cA7AAA7,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h,),
                    Text(
                      "${data.price.formatWithSpaces()} UZS",
                      style: TextStyle(
                        color: AppColor.yellowFFC,
                        fontSize: 16.sp,
                        letterSpacing: -1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTapDown: CacheService.getString("user_role") == "BUSINESS_OWNER" ||  CacheService.getString("user_role") == "MANAGER"  ? (TapDownDetails details) {
                  _showPopupMenu(context, details.globalPosition);
                } : (TapDownDetails details){},
                child: CacheService.getString("user_role") == "BUSINESS_OWNER" ||  CacheService.getString("user_role") == "MANAGER"  ? SvgPicture.asset(AppIcons.threeDot , width: 20.w,fit : BoxFit.cover) : SizedBox()
              )
            ],
          ),
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, Offset position) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        MediaQuery.of(context).size.width - position.dx,
        MediaQuery.of(context).size.height - position.dy,
      ),
      color: Colors.white,
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              SvgPicture.asset(AppIcons.edit2, width: 20.w),
              SizedBox(width: 12.w),
              Text("edit".tr()),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              AppService.changePage(
                context,
                BlocProvider.value(
                  value: homeBloc,
                  child: EditResourceScreen(resourceData: data),
                ),
              );
            });
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              SvgPicture.asset(AppIcons.delete, width: 20.w),
              SizedBox(width: 12.w),
              Text("delete".tr()),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              CenterDialog.deleteResourceDialog(
                context,
                name: data.name,
                id: data.id,
                onTapDelete: () {
                  homeBloc.add(DeleteResourceEvent(id: data.id));
                },
              );
            });
          },
        ),
      ],
    );
  }
}
