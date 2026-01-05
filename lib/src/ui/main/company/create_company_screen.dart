import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/model/api/main/home/category_model.dart';
import 'package:bandu_business/src/model/response/create_company_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/ui/main/company/screen/map_screen.dart';
import 'package:bandu_business/src/ui/main/company/screen/select_company_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/set_image_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/widget/main/create_company/open24.dart';
import 'package:bandu_business/src/widget/main/create_company/select_category_widget.dart';
import 'package:bandu_business/src/widget/main/create_company/week_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  TextEditingController nameController = TextEditingController();
  int selectedCategoryId = -1;
  bool isOpen24 = false;
  List<int> resourceCategoryIds = [];

  List<CategoryData>? categoryData;
  double? selectedLat;
  double? selectedLon;
  String selectedAddress = "";
  XFile? img;

  Map<String, dynamic> day = {};

  // Preview map controller
  YandexMapController? _previewController;
  List<MapObject> previewMarkers = [];
  bool open24 = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    context.read<HomeBloc>().add(GetCategoryEvent());
    context.read<HomeBloc>().add(GetResourceCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetCategorySuccessState) {
            categoryData = state.data.data;
          } else if (state is GetImageSuccessState) {
            img = state.img;
          } else if (state is GetResourceCategorySuccessState) {
            for (
              int i = 0;
              i < (state.data.length > 5 ? 5 : state.data.length);
              i++
            ) {
              resourceCategoryIds.add(state.data[i].id);
            }
          } else if (state is SaveCompanySuccessState) {
            AppService.successToast(context, "Company created successfully");
            Navigator.popUntil(context, (route) => route.isFirst);
            AppService.replacePage(
              context,
              BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: SelectCompanyScreen(),
              ),
            );
          } else if (state is HomeErrorState) {
            CenterDialog.errorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          bool loading = state is SaveCompanyLoadingState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarWidget(
                isAppName: false,
                text: "Create Company",
                isBack: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      SetImageWidget(isHome: true, img: img),
                      SizedBox(height: 20.h),
                      InputWidget(
                        controller: nameController,
                        title: "Company name",
                        hint: "Company name",
                      ),
                      SizedBox(height: 12.h),
                      if (categoryData != null)
                        SelectCategoryWidget(
                          onSelect: (d) {
                            selectedCategoryId = d;
                            setState(() {});
                          },
                          item: categoryData!,
                        ),
                      SizedBox(height: 20.h),
                      Open24Item(
                        onChange: (v) {
                          open24 = v;
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 20.h),
                      if(!open24)WeekItem(
                        onChange: (v) {
                          day = v;
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(height: 20.h),
                      _buildMapPreview(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              AppButton(
                onTap: () {
                  if (nameController.text.isEmpty ||
                      selectedLon == null ||
                      selectedLon == null ||
                      img == null) {
                    AppService.errorToast(
                      context,
                      "Please enter all the fields",
                    );
                    return;
                  }
                  final dt = CreateCompanyModel(
                    name: nameController.text,
                    location: Location(
                      address: selectedAddress,
                      latitude: selectedLat!,
                      longitude: selectedLon!,
                    ),
                    categoryIds: [selectedCategoryId],
                    resourceCategoryIds: resourceCategoryIds,
                    isOpen247: open24,
                    workingHours: open24 ? null : WorkingHours(
                      monday: Day(
                        open: day["monday"]["open"] ,
                        close: day["monday"]["close"] ,
                        closed: day["monday"]["closed"] ?? false,
                      ),
                      tuesday: Day(
                        open: day["tuesday"]["open"],
                        close: day["tuesday"]["close"],
                        closed: day["tuesday"]["closed"] ?? false,
                      ),
                      wednesday: Day(
                        open: day["wednesday"]["open"],
                        close: day["wednesday"]["close"],
                        closed: day["wednesday"]["closed"] ?? false,
                      ),
                      thursday: Day(
                        open: day["thursday"]["open"] ,
                        close: day["thursday"]["close"] ,
                        closed: day["thursday"]["closed"] ?? false,
                      ),
                      friday: Day(
                        open: day["friday"]["open"] ,
                        close: day["friday"]["close"] ,
                        closed: day["friday"]["closed"] ?? false,
                      ),
                      saturday: Day(
                        open: day["saturday"]["open"],
                        close: day["saturday"]["close"] ,
                        closed: day["saturday"]["closed"] ?? false,
                      ),
                      sunday: Day(
                        open: day["sunday"]["open"] ,
                        close: day["sunday"]["close"] ,
                        closed: day["sunday"]["closed"] ?? false,
                      ),
                    ),
                    images: [
                      ImageCreateModel(url: img!.path, index: 1, isMain: true),
                    ],
                  );
                  context.read<HomeBloc>().add(SaveCompanyEvent(data: dt));
                },
                loading: loading,
                text: "Save",
              ),
              SizedBox(height: 24.h),
            ],
          );
        },
      ),
    );
  }

  // -------------------------- MAP PREVIEW -----------------------------

  Widget _buildMapPreview() {
    final hasLoc = selectedLat != null && selectedLon != null;

    return GestureDetector(
      onTap: () {
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
          child: const Text(
            "Tap to select location",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  // -------------------------- MARKER UPDATE -----------------------------

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
