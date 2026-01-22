import 'dart:async';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';

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

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  YandexMapController? _controller;

  double selectedLat = 41.3111;
  double selectedLon = 69.2797;

  String selectedAddress = "Loading...";
  bool isMoving = false;
  double currentZoom = 15.0;
  
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _isListeningToLocation = false;
  bool _isControllerReady = false;
  double _compassHeading = 0;
  double? _userLat;
  double? _userLon;
  ScreenPoint? _userLocationScreenPoint;

  static const _cameraAnimation = MapAnimation(
    type: MapAnimationType.smooth,
    duration: 1.0,
  );

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    /// Agar initial location berilgan bo‘lsa → o‘sha joydan boshlanadi
    if (widget.initialLat != null && widget.initialLon != null) {
      selectedLat = widget.initialLat!;
      selectedLon = widget.initialLon!;
    }
    _startCompassListening();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  void _startCompassListening() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted && event.heading != null) {
        setState(() => _compassHeading = event.heading!);
      }
    });
  }

  Future<void> _updateUserLocationScreenPoint() async {
    if (_controller == null || _userLat == null || _userLon == null) return;
    final p = await _controller!.getScreenPoint(
      Point(latitude: _userLat!, longitude: _userLon!),
    );
    if (mounted) {
      setState(() => _userLocationScreenPoint = p);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _compassSubscription?.cancel();
    _compassSubscription = null;
    _stopLocationListening();
    super.dispose();
  }

  void _onMapMovingChanged(bool moving) {
    if (moving) {
      if (!_bounceController.isAnimating) {
        _bounceController.repeat(reverse: true);
      }
    } else {
      _bounceController.stop();
      _bounceController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: _onCreated,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,

            onCameraPositionChanged: (cameraPos, reason, finished) async {
              selectedLat = cameraPos.target.latitude;
              selectedLon = cameraPos.target.longitude;
              currentZoom = cameraPos.zoom;

              if (!finished) {
                if (!isMoving) {
                  setState(() => isMoving = true);
                  _onMapMovingChanged(true);
                }
                _updateUserLocationScreenPoint();
                return;
              }

              setState(() => isMoving = false);
              _onMapMovingChanged(false);
              await _getAddress(selectedLat, selectedLon);
              _updateUserLocationScreenPoint();
            },
          ),

          Center(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  final scale = 1.0 + (isMoving ? 0.06 * _bounceAnimation.value : 0);
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: AppSvgAsset(
                  AppIcons.map,
                  width: 50.w,
                  height: 50.w,
                ),
              ),
            ),
          ),

          if (_userLocationScreenPoint != null)
            Positioned(
              left: _userLocationScreenPoint!.x - 25.w,
              top: _userLocationScreenPoint!.y - 25.w,
              child: IgnorePointer(
                child: AnimatedRotation(
                  turns: _compassHeading / 360,
                  duration: const Duration(milliseconds: 150),
                  child: Image.asset(
                    AppImages.location,
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
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

  Future<void> _onCreated(YandexMapController controller) async {
    _controller = controller;
    _isControllerReady = true;

    await _controller!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: selectedLat, longitude: selectedLon),
          zoom: 15,
        ),
      ),
      animation: _cameraAnimation,
    );

    await _getAddress(selectedLat, selectedLon);
    _startLocationListening();
    _fetchInitialUserLocation();
  }

  Future<void> _fetchInitialUserLocation() async {
    if (_controller == null) return;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted && _controller != null) {
        _userLat = position.latitude;
        _userLon = position.longitude;
        await _updateUserLocationScreenPoint();
        setState(() {});
      }
    } catch (_) {}
  }

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
    if (_controller == null) return;
    currentZoom = (currentZoom + 1).clamp(1.0, 20.0);
    await _controller!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: selectedLat, longitude: selectedLon),
          zoom: currentZoom,
        ),
      ),
    );
  }

  Future<void> _zoomOut() async {
    if (_controller == null) return;
    currentZoom = (currentZoom - 1).clamp(1.0, 20.0);
    await _controller!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: selectedLat, longitude: selectedLon),
          zoom: currentZoom,
        ),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    if (_controller == null) {
      return;
    }

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppService.errorToast(context, "pleaseEnableLocationServices".tr());
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          AppService.errorToast(context, "pleaseGrantLocationPermission".tr());
          await Geolocator.openAppSettings();
        }
        return;
      }
      if (permission == LocationPermission.denied) {
        if (mounted) {
          AppService.errorToast(context, "pleaseGrantLocationPermission".tr());
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted && _controller != null) {
        selectedLat = position.latitude;
        selectedLon = position.longitude;
        _userLat = position.latitude;
        _userLon = position.longitude;

        await _controller!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(latitude: selectedLat, longitude: selectedLon),
              zoom: 15,
            ),
          ),
          animation: _cameraAnimation,
        );

        await _getAddress(selectedLat, selectedLon);
        _updateUserLocationScreenPoint();
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        AppService.errorToast(context, "unknownError".tr());
      }
    }
  }
  
  Future<void> _startLocationListening() async {
    if (!_isControllerReady || _controller == null) {
      return;
    }

    if (_isListeningToLocation) {
      return;
    }

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }

      _isListeningToLocation = true;

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen(
        (Position position) {
          if (mounted && _controller != null) {
            _userLat = position.latitude;
            _userLon = position.longitude;
            setState(() {
              selectedLat = position.latitude;
              selectedLon = position.longitude;
            });

            _controller!.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: Point(latitude: selectedLat, longitude: selectedLon),
                  zoom: currentZoom,
                ),
              ),
            );

            _getAddress(selectedLat, selectedLon);
            _updateUserLocationScreenPoint();
          }
        },
        onError: (error) {
          _isListeningToLocation = false;
        },
      );
    } catch (e) {
      _isListeningToLocation = false;
    }
  }
  
  void _stopLocationListening() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _isListeningToLocation = false;
  }
}
