import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/model/api/main/home/icon_model.dart' as icon_model;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectPlaceItem extends StatefulWidget {
  final Function(int, String)? onIconSelected;
  final int? selectedIconId;

  const SelectPlaceItem({super.key, this.onIconSelected, this.selectedIconId});

  @override
  State<SelectPlaceItem> createState() => _SelectPlaceItemState();
}

class _SelectPlaceItemState extends State<SelectPlaceItem> {
  int? selectedIconId;

  @override
  void initState() {
    super.initState();
    selectedIconId = widget.selectedIconId;
    context.read<HomeBloc>().add(GetIconsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeErrorState) {
          CenterDialog.errorDialog(context, state.message);
        }
      },
      builder: (context, state) {
        List<icon_model.IconData> icons = [];
        bool isLoading = state is GetIconsLoadingState;

        if (state is GetIconsSuccessState) {
          icons = state.data;
        }

        return Container(
          constraints: BoxConstraints(maxHeight: 600.h, minHeight: 200.h),
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.r),
              topLeft: Radius.circular(16.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (icons.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      "noIconsAvailable".tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.grey58,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.w,
                    ),
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      final icon = icons[index];
                      final isSelected = selectedIconId == icon.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIconId = icon.id;
                          });
                        },
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.yellowFFC.withOpacity(0.6)
                                : AppColor.grey58.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: isSelected
                                ? Border.all(
                                    width: 2.w,
                                    color: AppColor.yellowFFC,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: SvgPicture.network(
                              icon.url,
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.contain,
                              placeholderBuilder: (context) => Container(
                                width: 40.w,
                                height: 40.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 10.h),
              AppButton(
                onTap: () {
                  if (selectedIconId != null && widget.onIconSelected != null) {
                    try {
                      final selectedIcon = icons.firstWhere((icon) => icon.id == selectedIconId);
                      widget.onIconSelected!(selectedIconId!, selectedIcon.url);
                    } catch (e) {
                    }
                  }
                  Navigator.pop(context);
                },
                text: "selectIcon".tr(),
                margin: EdgeInsets.zero,
                isGradient: selectedIconId != null,
                backColor: selectedIconId == null ? AppColor.greyE5 : null,
                txtColor: selectedIconId == null ? AppColor.greyA7 : null,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}
