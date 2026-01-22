import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/auth/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperFunctions {
  HelperFunctions._();

  static Future<bool> requestLocationPermission() async {
    try {
      PermissionStatus status = await Permission.locationWhenInUse.status;
      
      if (status.isGranted) {
        return true;
      }
      
      if (status.isDenied) {
        status = await Permission.locationWhenInUse.request();
        if (status.isGranted) {
          return true;
        }
      }
      
      if (status.isPermanentlyDenied) {
        return false;
      }
      
      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  static void saveLoginData(LoginModel data) {
    if (data.tokens.accessToken.isNotEmpty) {
      CacheService.saveToken(data.tokens.accessToken);
    }
    if (data.data.user.fullName.isNotEmpty) {
      CacheService.saveString("full_name", data.data.user.fullName);
    }
    if (data.data.user.profilePicture.isNotEmpty) {
      CacheService.saveString("image", data.data.user.profilePicture);
    }
    if (data.data.phoneNumber.isNotEmpty) {
      CacheService.saveString("phone", data.data.phoneNumber);
    }
    if (data.data.user.role.isNotEmpty) {
      CacheService.saveString("user_role", data.data.user.role);
      print("User role saqlandi: ${data.data.user.role}");
    }
    if (data.data.user.roles.isNotEmpty) {
      CacheService.saveStringList("user_roles", data.data.user.roles);
      print("User roles saqlandi: ${data.data.user.roles.join(", ")}");
    }
  }

  static String errorText(dynamic dt) {
    try {
      if (dt is String) {
        print(dt);
        print("Man u kelgan responce error");
        return dt;
      } else if (dt is Map<String, dynamic>) {
        if (dt.containsKey('message')) {
          return dt['message'].toString();
        } else if (dt.containsKey('error')) {
          return dt['error'].toString();
        } else {
          return 'Unknown error occurred';
        }
      } else {
        return dt.toString();
      }
    } catch (e) {
      return 'Unknown error occurred';
    }
  }

  ///download image from url
  static Future<Uint8List?> downloadImage(String url) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = <int>[];
        await for (var chunk in response) {
          bytes.addAll(chunk);
        }
        client.close();
        return Uint8List.fromList(bytes);
      } else {
        debugPrint('HttpClient statusCode: ${response.statusCode}');
        client.close();
        return null;
      }
    } catch (e) {
      debugPrint('HttpClient error: $e');
      return null;
    }
  }

  ///open google map

  static Future<void> openGoogleMapsNavigation({
    required double latitude,
    required double longitude,
  }) async {
    final googleUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(
        Uri.parse(googleUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  static int? getCompanyId() {
    return CacheService.getInt("select_company") ?? -1;
  }

  /// Render widgetni image ga aylantirish
  static Future<Uint8List> widgetToImage(GlobalKey key) async {
    // RepaintBoundary chizilishi tugaguncha kutish
    await Future.delayed(Duration(milliseconds: 20));
    await WidgetsBinding.instance.endOfFrame;

    final context = key.currentContext;
    if (context == null) throw Exception("RepaintBoundary context is NULL");
    if (!context.mounted) throw Exception("Context is not mounted");
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) throw Exception("RenderRepaintBoundary is NULL");

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  static String getCategoryIconByIkpuCode(String ikpuCode) {
    switch (ikpuCode) {
      case "11702002001000000":
        return AppImages.barberSelect;
      case "07615002001000000":
        return AppImages.carwashSelect;
      case "10902003001000000":
        return AppIcons.placeSelect;
      case "02106999999000000":
        return AppImages.restaurantSelect;
      default:
        return AppIcons.placeSelect;
    }
  }

  static String getCategoryIconByIkpuCodeWithSelection(String ikpuCode, bool isSelected) {
    if (ikpuCode.isEmpty) {
      return isSelected ? AppIcons.placeOn : AppIcons.place;
    }
    
    switch (ikpuCode) {
      case "11702002001000000":
        return isSelected ? AppImages.barberSelect : AppImages.barberUnselect;
      case "07615002001000000":
        return isSelected ? AppImages.carwashSelect : AppImages.carwashUnselect;
      case "10902003001000000":
        return isSelected ? AppIcons.placeOn : AppIcons.place;
      case "02106999999000000":
        return isSelected ? AppImages.restaurantSelect : AppImages.restaurantUnselect;
      default:
        return isSelected ? AppIcons.placeOn : AppIcons.place;
    }
  }
}
