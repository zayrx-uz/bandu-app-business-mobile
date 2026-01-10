import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart'
    hide Image;
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceWidget extends StatelessWidget {
  const ResourceWidget({super.key, required this.data});

  final Datum data;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        // Check if this specific resource is being deleted
        final isDeleting = state is DeleteResourceLoadingState && 
                          state.resourceId == data.id;
        
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(12.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                offset: Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              data.images.isNotEmpty
                  ? CustomNetworkImage(
                      imageUrl: data.images.first.url,
                      borderRadius: 12.r,
                      width: 72.w,
                      height: 72.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 36.w,
                        color: Colors.grey[600],
                      ),
                    ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${data.price.formatWithSpaces()} UZS",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppIconButton(
                          icon: AppIcons.trash,
                          onTap: () {
                            CenterDialog.deleteResourceDialog(
                              context,
                              id: data.id,
                              name: data.name,
                              onTapDelete: (){
                                Navigator.pop(context);
                                BlocProvider.of<HomeBloc>(context).add(DeleteResourceEvent(id: data.id));
                              }
                            );
                          },
                          loading: isDeleting,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
