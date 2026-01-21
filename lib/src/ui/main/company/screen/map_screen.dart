import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapScreen extends StatefulWidget {
  final Function(double lat, double lon, String address) onSelect;

  /// Agar user ilgari tanlagan bo‘lsa — shu keladi
  final double? initialLat;
  final double? initialLon;

  const MapScreen({
    super.key,
    required this.onSelect,
    this.initialLat,
    this.initialLon,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController _controller;

  double selectedLat = 41.3111;
  double selectedLon = 69.2797;

  String selectedAddress = "Loading...";
  bool isMoving = false;
  double currentZoom = 15.0;

  @override
  void initState() {
    super.initState();

    /// Agar initial location berilgan bo‘lsa → o‘sha joydan boshlanadi
    if (widget.initialLat != null && widget.initialLon != null) {
      selectedLat = widget.initialLat!;
      selectedLon = widget.initialLon!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAP
          YandexMap(
            onMapCreated: _onCreated,

            onCameraPositionChanged: (cameraPos, reason, finished) async {
              selectedLat = cameraPos.target.latitude;
              selectedLon = cameraPos.target.longitude;
              currentZoom = cameraPos.zoom;

              if (!finished) {
                if (!isMoving) {
                  setState(() => isMoving = true);
                }
                return;
              }

              setState(() => isMoving = false);
              await _getAddress(selectedLat, selectedLon);
            },
          ),

          Center(
            child: Image.asset(AppImages.myLocation, width: 50.w, height: 50.w),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBarWidget(
              isAppName: false,
              text: "selectLocation".tr(),
              isBack: true,
            ),
          ),

          Positioned(
            right: 16.w,
            bottom: 200.h,
            child: Column(
              children: [
                _buildZoomButton(Icons.add, () => _zoomIn()),
                SizedBox(height: 8.h),
                _buildZoomButton(Icons.remove, () => _zoomOut()),
                SizedBox(height: 8.h),
                _buildCurrentLocationButton(),
              ],
            ),
          ),

          /// ADDRESS CARD
          Positioned(
            bottom: 110.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                isMoving ? "loading".tr() : selectedAddress,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          /// SAVE BUTTON
          Positioned(
            bottom: 40.h,
            left: 16.w,
            right: 16.w,
            child: AppButton(
              margin: EdgeInsets.zero,
              onTap: () {
                widget.onSelect(selectedLat, selectedLon, selectedAddress);
                Navigator.pop(context);
              },
              text: "save".tr(),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------- MAP CREATED ------------------------

  Future<void> _onCreated(YandexMapController controller) async {
    _controller = controller;

    await _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: selectedLat, longitude: selectedLon),
          zoom: 15,
        ),
      ),
    );

    await _getAddress(selectedLat, selectedLon);
  }

  // -------------------- GET ADDRESS --------------------------

  Future<void> _getAddress(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        selectedAddress =
            "${p.street ?? ""}, ${p.locality ?? ""}, ${p.country ?? ""}";
      } else {
        selectedAddress = "addressNotFound".tr();
      }
    } catch (_) {
      selectedAddress = "addressNotFound".tr();
    }

    setState(() {});
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColor.black, size: 20.sp),
      ),
    );
  }

  Widget _buildCurrentLocationButton() {
    return GestureDetector(
      onTap: _goToCurrentLocation,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AppSvgAsset(
            AppIcons.location,
            width: 20.w,
            height: 20.w,
            color: AppColor.yellowFFC,
          ),
        ),
      ),
    );
  }

  Future<void> _zoomIn() async {
    currentZoom = (currentZoom + 1).clamp(1.0, 20.0);
    await _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: selectedLat, longitude: selectedLon),
          zoom: currentZoom,
        ),
      ),
    );
  }

  Future<void> _zoomOut() async {
    currentZoom = (currentZoom - 1).clamp(1.0, 20.0);
    await _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: selectedLat, longitude: selectedLon),
          zoom: currentZoom,
        ),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    final hasPermission = await HelperFunctions.requestLocationPermission();
    if (!hasPermission) {
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      selectedLat = position.latitude;
      selectedLon = position.longitude;

      await _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: selectedLat, longitude: selectedLon),
            zoom: 15,
          ),
        ),
      );

      await _getAddress(selectedLat, selectedLon);
    } catch (e) {
      selectedAddress = "locationError".tr();
      setState(() {});
    }
  }
}
