import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/model/api/main/home/category_model.dart';
import 'package:bandu_business/src/model/api/main/home/company_detail_model.dart';
import 'package:bandu_business/src/model/response/create_company_model.dart'
as create_model;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/company/screen/map_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/set_image_widget.dart';
import 'package:bandu_business/src/widget/dialog/bottom_dialog.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/widget/main/create_company/open24.dart';
import 'package:bandu_business/src/widget/main/create_company/select_category_widget.dart';
import 'package:bandu_business/src/widget/main/create_company/week_item.dart';
import 'package:bandu_business/src/widget/main/settings/resource/select_resource_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../widget/auth/set_image_widget.dart' as DeviceHelper;

class CreateCompanyScreen extends StatefulWidget {
  final int? companyId;
  const CreateCompanyScreen({super.key, this.companyId});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  TextEditingController nameController = TextEditingController();
  int? selectedCategoryId;
  bool isOpen24 = false;
  List<int> resourceCategoryIds = [];

  List<CategoryData>? categoryData;
  double? selectedLat;
  double? selectedLon;
  String selectedAddress = "";
  XFile? img;

  Map<String, dynamic> day = {};

  YandexMapController? _previewController;
  String? _networkImageUrl;
  List<MapObject> previewMarkers = [];
  bool open24 = false;
  int? selectedIconId;
  String? selectedIconUrl;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {});
    });
    getData();
    if (widget.companyId != null) {
      context.read<HomeBloc>().add(GetCompanyDetailEvent(companyId: widget.companyId!));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void getData() {
    context.read<HomeBloc>().add(GetCategoryEvent());
    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId > 0 && widget.companyId == null) {
      context.read<HomeBloc>().add(GetResourceCategoryEvent(companyId: companyId));
    }
  }

  void _loadCompanyData(CompanyDetailData company) {
    nameController.text = company.name;
    selectedCategoryId = company.categories.isNotEmpty ? company.categories.first.id : null;
    open24 = company.isOpen247;
    isOpen24 = company.isOpen247;
    selectedLat = company.location.latitude;
    selectedLon = company.location.longitude;
    selectedAddress = company.location.address;
    resourceCategoryIds = company.resourceCategories.map((e) => e.id).toList();

    if (company.icon != null && company.icon!.url.isNotEmpty) {
      selectedIconId = company.icon!.id;
      selectedIconUrl = company.icon!.url;
    }

    if (company.images.isNotEmpty) {
      final mainImage = company.images.firstWhere(
            (img) => img.isMain,
        orElse: () => company.images[0],
      );
      _networkImageUrl = mainImage.url;
    } else if (company.logo != null && company.logo!.isNotEmpty) {
      _networkImageUrl = company.logo;
    }

    if (!open24) {
      day = {
        "monday": {
          "open": company.workingHours.monday.closed ? null : company.workingHours.monday.open,
          "close": company.workingHours.monday.closed ? null : company.workingHours.monday.close,
          "closed": company.workingHours.monday.closed,
        },
        "tuesday": {
          "open": company.workingHours.tuesday.closed ? null : company.workingHours.tuesday.open,
          "close": company.workingHours.tuesday.closed ? null : company.workingHours.tuesday.close,
          "closed": company.workingHours.tuesday.closed,
        },
        "wednesday": {
          "open": company.workingHours.wednesday.closed ? null : company.workingHours.wednesday.open,
          "close": company.workingHours.wednesday.closed ? null : company.workingHours.wednesday.close,
          "closed": company.workingHours.wednesday.closed,
        },
        "thursday": {
          "open": company.workingHours.thursday.closed ? null : company.workingHours.thursday.open,
          "close": company.workingHours.thursday.closed ? null : company.workingHours.thursday.close,
          "closed": company.workingHours.thursday.closed,
        },
        "friday": {
          "open": company.workingHours.friday.closed ? null : company.workingHours.friday.open,
          "close": company.workingHours.friday.closed ? null : company.workingHours.friday.close,
          "closed": company.workingHours.friday.closed,
        },
        "saturday": {
          "open": company.workingHours.saturday.closed ? null : company.workingHours.saturday.open,
          "close": company.workingHours.saturday.closed ? null : company.workingHours.saturday.close,
          "closed": company.workingHours.saturday.closed,
        },
        "sunday": {
          "open": company.workingHours.sunday.closed ? null : company.workingHours.sunday.open,
          "close": company.workingHours.sunday.closed ? null : company.workingHours.sunday.close,
          "closed": company.workingHours.sunday.closed,
        },
      };
    } else {
      day = {};
    }
    setState(() {});
  }

  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusKeyboard,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is GetCategorySuccessState) {
              categoryData = state.data.data;
              setState(() {});
            } else if (state is GetImageSuccessState) {
              img = state.img;
              _networkImageUrl = null;
              setState(() {});
            } else if (state is GetResourceCategorySuccessState) {
              if (widget.companyId == null) {
                for (
                int i = 0;
                i < (state.data.length > 5 ? 5 : state.data.length);
                i++
                ) {
                  resourceCategoryIds.add(state.data[i].id);
                }
              }
            } else if (state is GetCompanyDetailSuccessState) {
              _loadCompanyData(state.data);
            } else if (state is SaveCompanySuccessState) {
              AppService.successToast(
                context,
                widget.companyId != null
                    ? "companyUpdatedSuccessfully".tr()
                    : "companyCreatedSuccessfully".tr(),
              );
              Navigator.pop(context);
            } else if (state is UpdateCompanySuccessState) {
              if (selectedIconUrl != null && selectedIconUrl!.isNotEmpty) {
                CacheService.savePlaceIcon(selectedIconUrl!);
                RxBus.post(1, tag: "PLACE_ICON_UPDATED");
              }
              AppService.successToast(context, "companyUpdatedSuccessfully".tr());
              Navigator.pop(context);
            } else if (state is HomeErrorState) {
              CenterDialog.errorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            bool loading = state is SaveCompanyLoadingState ||
                state is UpdateCompanyLoadingState;

            bool isFormValid() {
              if (nameController.text.isEmpty) return false;
              if (selectedCategoryId == null) return false;
              if (selectedIconId == null) return false;
              if (selectedLat == null || selectedLon == null) return false;
              if (widget.companyId == null && img == null) return false;
              if (!open24) {
                if (day.isEmpty) return false;
                bool hasOpenDay = false;
                for (var dayKey in day.keys) {
                  final dayData = day[dayKey];
                  if (dayData != null && dayData["closed"] == false) {
                    if (dayData["open"] == null || dayData["close"] == null) {
                      return false;
                    }
                    hasOpenDay = true;
                  }
                }
                if (!hasOpenDay) return false;
              }
              return true;
            }

            final bool isValid = isFormValid();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBarWidget(
                  isAppName: false,
                  text: widget.companyId != null ? "updateCompany".tr() : "createCompany".tr(),
                  isBack: true,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _unfocusKeyboard,
                    behavior: HitTestBehavior.opaque,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                      SizedBox(height: 20.h),
                      SetImageWidget(
                        isHome: true,
                        img: img,
                        networkImage: _networkImageUrl,
                        onButtonTap: _unfocusKeyboard,
                      ),
                      SizedBox(height: 20.h),
                      InputWidget(
                        controller: nameController,
                        title: "companyName".tr(),
                        hint: "companyName".tr(),
                      ),
                      SizedBox(height: 12.h),
                      if (categoryData != null)
                        SelectCategoryWidget(
                          onSelect: (d) {
                            _unfocusKeyboard();
                            setState(() {
                              selectedCategoryId = d;
                            });
                          },
                          item: categoryData!,
                          selectedId: selectedCategoryId,
                        ),
                        SizedBox(height: 12.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "placeIcon".tr(),
                                style: AppTextStyle.f500s16.copyWith(
                                  color: AppColor.black09,
                                  fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                                ),
                              ),
                              SizedBox(height: 10.h,),
                              GestureDetector(
                                onTap: (){
                                  BottomDialog.selectPlaceIcon(
                                    context,
                                    onIconSelected: (iconId, iconUrl) {
                                      setState(() {
                                        selectedIconId = iconId;
                                        selectedIconUrl = iconUrl;
                                      });
                                    },
                                    selectedIconId: selectedIconId,
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 10.w , vertical: 10.h),
                                  decoration: BoxDecoration(
                                      color : Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                          width: 1.w,
                                          color : selectedIconId == null 
                                              ? Colors.grey.withValues(alpha: 0.4)
                                              : AppColor.yellowFFC
                                      )
                                  ),
                                  child : Row(
                                    children: [
                                      if (selectedIconUrl != null)
                                        SvgPicture.network(
                                          selectedIconUrl!,
                                          width: 24.w,
                                          height: 24.w,
                                          fit: BoxFit.cover,
                                          placeholderBuilder: (context) => Container(
                                            width: 24.w,
                                            height: 24.w,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        )
                                      else
                                        SvgPicture.asset(AppIcons.money , width: 24.w,fit : BoxFit.cover),
                                      SizedBox(width: 10.w,),
                                      Expanded(
                                        child: Text(
                                          selectedIconId != null 
                                              ? "iconSelected".tr() 
                                              : "iconDescription".tr(),
                                          style: TextStyle(
                                            color : selectedIconId != null
                                                ? AppColor.black09
                                                : Colors.black.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                      SizedBox(height: 20.h),
                      if (widget.companyId != null)
                        BlocBuilder<HomeBloc, HomeState>(
                          buildWhen: (previous, current) {
                            return current is GetResourceCategorySuccessState ||
                                current is GetResourceCategoryLoadingState ||
                                current is HomeErrorState;
                          },
                          builder: (context, state) {
                            if (state is GetResourceCategorySuccessState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      "resourceCategories".tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  SelectResourceWidget(
                                    onCategorySelected: (categoryId) {
                                      _unfocusKeyboard();
                                      if (categoryId > 0 && !resourceCategoryIds.contains(categoryId)) {
                                        setState(() {
                                          resourceCategoryIds.add(categoryId);
                                        });
                                      }
                                    },
                                  ),
                                  if (resourceCategoryIds.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                      child: Wrap(
                                        spacing: 8.w,
                                        runSpacing: 8.h,
                                        children: resourceCategoryIds.map((catId) {
                                          try {
                                            final category = state.data.firstWhere(
                                                  (cat) => cat.id == catId,
                                            );
                                            return Chip(
                                              label: Text(category.name),
                                              onDeleted: () {
                                                _unfocusKeyboard();
                                                setState(() {
                                                  resourceCategoryIds.remove(catId);
                                                });
                                              },
                                              deleteIcon: Icon(Icons.close, size: 18.sp),
                                            );
                                          } catch (e) {
                                            return SizedBox.shrink();
                                          }
                                        }).toList(),
                                      ),
                                    ),
                                  SizedBox(height: 20.h),
                                ],
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),

                      Open24Item(
                        value: open24,
                        onChange: (v) {
                          open24 = v;
                          isOpen24 = v;
                          setState(() {});
                        },
                        onTap: _unfocusKeyboard,
                      ),
                      SizedBox(height: 20.h),
                      if (!open24)
                        WeekItem(
                          initialData: day,
                          onChange: (v) {
                            day = v;
                          },
                          onTap: _unfocusKeyboard,
                        ),
                      SizedBox(height: 12.h),
                      SizedBox(height: 20.h),
                      _buildMapPreview(),
                      SizedBox(height: 12.h),
                      AppButton(
                        onTap: isValid ? () {
                          _unfocusKeyboard();
                          if (nameController.text.isEmpty) {
                            AppService.errorToast(
                              context,
                              "pleaseEnterCompanyName".tr(),
                            );
                            return;
                          }
                          if (selectedCategoryId == null) {
                            AppService.errorToast(
                              context,
                              "pleaseSelectCategory".tr(),
                            );
                            return;
                          }
                          if (selectedIconId == null) {
                            AppService.errorToast(
                              context,
                              "pleaseSelectIcon".tr(),
                            );
                            return;
                          }
                          if (selectedLat == null || selectedLon == null) {
                            AppService.errorToast(
                              context,
                              "pleaseSelectLocation".tr(),
                            );
                            return;
                          }
                          if (!open24) {
                            if (day.isEmpty) {
                              AppService.errorToast(
                                context,
                                "pleaseSetWorkingHours".tr(),
                              );
                              return;
                            }
                            bool hasOpenDay = false;
                            for (var dayKey in day.keys) {
                              final dayData = day[dayKey];
                              if (dayData != null && dayData["closed"] == false) {
                                if (dayData["open"] == null || dayData["close"] == null) {
                                  AppService.errorToast(
                                    context,
                                    "pleaseSetWorkingHours".tr(),
                                  );
                                  return;
                                }
                                hasOpenDay = true;
                              }
                            }
                            if (!hasOpenDay) {
                              AppService.errorToast(
                                context,
                                "pleaseSetWorkingHours".tr(),
                              );
                              return;
                            }
                          }
                          final List<int> categoryIdsList = selectedCategoryId != null ? [selectedCategoryId!] : [];

                          create_model.WorkingHours? workingHoursValue;
                          if (!open24 && day.isNotEmpty) {
                            workingHoursValue = create_model.WorkingHours(
                              monday: create_model.Day(
                                open: (day["monday"]?["closed"] == true) ? null : day["monday"]?["open"],
                                close: (day["monday"]?["closed"] == true) ? null : day["monday"]?["close"],
                                closed: day["monday"]?["closed"] ?? false,
                              ),
                              tuesday: create_model.Day(
                                open: (day["tuesday"]?["closed"] == true) ? null : day["tuesday"]?["open"],
                                close: (day["tuesday"]?["closed"] == true) ? null : day["tuesday"]?["close"],
                                closed: day["tuesday"]?["closed"] ?? false,
                              ),
                              wednesday: create_model.Day(
                                open: (day["wednesday"]?["closed"] == true) ? null : day["wednesday"]?["open"],
                                close: (day["wednesday"]?["closed"] == true) ? null : day["wednesday"]?["close"],
                                closed: day["wednesday"]?["closed"] ?? false,
                              ),
                              thursday: create_model.Day(
                                open: (day["thursday"]?["closed"] == true) ? null : day["thursday"]?["open"],
                                close: (day["thursday"]?["closed"] == true) ? null : day["thursday"]?["close"],
                                closed: day["thursday"]?["closed"] ?? false,
                              ),
                              friday: create_model.Day(
                                open: (day["friday"]?["closed"] == true) ? null : day["friday"]?["open"],
                                close: (day["friday"]?["closed"] == true) ? null : day["friday"]?["close"],
                                closed: day["friday"]?["closed"] ?? false,
                              ),
                              saturday: create_model.Day(
                                open: (day["saturday"]?["closed"] == true) ? null : day["saturday"]?["open"],
                                close: (day["saturday"]?["closed"] == true) ? null : day["saturday"]?["close"],
                                closed: day["saturday"]?["closed"] ?? false,
                              ),
                              sunday: create_model.Day(
                                open: (day["sunday"]?["closed"] == true) ? null : day["sunday"]?["open"],
                                close: (day["sunday"]?["closed"] == true) ? null : day["sunday"]?["close"],
                                closed: day["sunday"]?["closed"] ?? false,
                              ),
                            );
                          }

                          List<create_model.ImageCreateModel> imagesList = [];
                          if (img != null) {
                            imagesList.add(
                              create_model.ImageCreateModel(
                                url: img!.path,
                                index: 1,
                                isMain: true,
                              ),
                            );
                          } else if (widget.companyId != null && _networkImageUrl != null && _networkImageUrl!.isNotEmpty) {
                            imagesList.add(
                              create_model.ImageCreateModel(
                                url: _networkImageUrl!,
                                index: 1,
                                isMain: true,
                              ),
                            );
                          }

                          final updateModel = create_model.UpdateCompanyModel(
                            name: nameController.text,
                            location: create_model.Location(
                              address: selectedAddress,
                              latitude: selectedLat!,
                              longitude: selectedLon!,
                            ),
                            categoryIds: categoryIdsList,
                            resourceCategoryIds: resourceCategoryIds,
                            isOpen247: open24,
                            serviceTypeId: 1,
                            workingHours: workingHoursValue,
                            images: imagesList,
                            iconId: selectedIconId,
                          );

                          if (widget.companyId != null) {
                            context.read<HomeBloc>().add(
                              UpdateCompanyEvent(
                                companyId: widget.companyId!,
                                data: updateModel,
                              ),
                            );
                          } else {
                            final createModel = create_model.CreateCompanyModel(
                              name: updateModel.name,
                              location: updateModel.location,
                              categoryIds: updateModel.categoryIds,
                              resourceCategoryIds: [],
                              isOpen247: updateModel.isOpen247,
                              serviceTypeId: updateModel.serviceTypeId,
                              workingHours: updateModel.workingHours,
                              images: updateModel.images,
                              iconId: selectedIconId,
                            );
                            context.read<HomeBloc>().add(SaveCompanyEvent(data: createModel));
                          }
                        } : () {
                          _unfocusKeyboard();
                        },
                        loading: loading,
                        isGradient: isValid,
                        backColor: isValid ? null : AppColor.greyE5,
                        txtColor: isValid ? null : AppColor.greyA7,
                        text: widget.companyId != null ? "update".tr() : "save".tr(),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                    ),
                  ),


              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    final hasLoc = selectedLat != null && selectedLon != null;

    return GestureDetector(
      onTap: () {
        _unfocusKeyboard();
        AppService.changePage(
          context,
          MapScreen(
            initialLat: selectedLat,
            initialLon: selectedLon,
            onSelect: (lat, lon, address) {
              setState(() {
                selectedLat = lat;
                selectedLon = lon;
                selectedAddress = address;
              });
              _updatePreviewMarker();
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 220.h,
        decoration: BoxDecoration(
          color: AppColor.greyF4,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(width: 1, color: AppColor.greyE5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            YandexMap(
              onMapCreated: (ctrl) async {
                _previewController = ctrl;

                final start = hasLoc
                    ? Point(latitude: selectedLat!, longitude: selectedLon!)
                    : const Point(latitude: 41.3111, longitude: 69.2797);

                await ctrl.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: start, zoom: hasLoc ? 16 : 12),
                  ),
                );

                if (hasLoc) _updatePreviewMarker();
              },

              tiltGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,

              mapObjects: previewMarkers,
            ),

            if (!hasLoc) _buildBlur(),

            if (hasLoc)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    selectedAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlur() {
    return Container(
      color: Colors.black.withValues(alpha: 0.25),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            "tapToSelectLocation".tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  void _updatePreviewMarker() {
    if (selectedLat == null || selectedLon == null) return;

    final mark = PlacemarkMapObject(
      opacity: 1,
      mapId: const MapObjectId("prev_marker"),
      point: Point(latitude: selectedLat!, longitude: selectedLon!),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(AppImages.myLocation),
          anchor: const Offset(0.5, 1),
          scale: 1,
        ),
      ),
    );

    setState(() {
      previewMarkers = [mark];
    });

    _previewController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: selectedLat!, longitude: selectedLon!),
          zoom: 16,
        ),
      ),
    );
  }
}