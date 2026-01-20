import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart'
    hide Image;
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/ui/main/settings/resource/edit_resource_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourceWidgetGrid extends StatelessWidget {
  const ResourceWidgetGrid({super.key, required this.data});

  final Datum data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        data.images.isNotEmpty
            ? CustomNetworkImage(
          imageUrl: data.images.first.url,
          borderRadius: 12.r,
          width: double.infinity,
          height: 112.h,
          fit: BoxFit.cover,
        ) : Container(
          height: 112.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.food,
              width: 64.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 11.h,),
        Row(
          children: [
            Flexible(
              child: Text(
                data.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${data.price.formatWithSpaces()} UZS",
              style: TextStyle(
                color: AppColor.yellowFFC,
                fontSize: 16.sp,
                letterSpacing: -1,
                fontWeight: FontWeight.w900,
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                _showPopupMenu(context, details.globalPosition);
              },
              child: AppSvgAsset(AppIcons.threeDot , width: 20.w,fit : BoxFit.cover)
            )
          ],
        )
      ],
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
