import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geocoding/geocoding.dart';
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

  double selectedLat = 41.3111; // default Toshkent
  double selectedLon = 69.2797; // default Toshkent

  String selectedAddress = "Loading...";
  bool isMoving = false;

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

          /// CENTER LOCATION ICON
          Center(
            child: Image.asset(AppImages.myLocation, width: 50.w, height: 50.w),
          ),
          Positioned(
            child: Column(
              children: [
                TopBarWidget(
                  isAppName: false,
                  text: "Select location",
                  isBack: true,
                ),
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
                isMoving ? "Loading..." : selectedAddress,
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
              text: "Save",
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
        selectedAddress = "Address not found";
      }
    } catch (_) {
      selectedAddress = "Address not found";
    }

    setState(() {});
  }
}
