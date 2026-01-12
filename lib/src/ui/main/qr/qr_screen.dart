// import 'dart:convert';
// import 'dart:io';
// import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
// import 'package:bandu_business/src/model/api/main/qr/barcode_model.dart';
// import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
// import 'package:bandu_business/src/ui/main/qr/screen/qr_booking_screen.dart';
// import 'package:bandu_business/src/ui/main/qr/screen/qr_detail_screen.dart';
// import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
//
// class QrScreen extends StatefulWidget {
//   const QrScreen({super.key});
//
//   @override
//   State<QrScreen> createState() => _QrScreenState();
// }
//
// class _QrScreenState extends State<QrScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   Barcode? result;
//   bool _bottomSheetOpened = false;
//   late BuildContext sheetContext;
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller?.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller?.resumeCamera();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoScaffold(
//       body: Builder(
//         builder: (context) {
//           sheetContext = context;
//           return CupertinoPageScaffold(
//             backgroundColor: Colors.white,
//             child: Scaffold(
//               backgroundColor: Colors.black,
//               body: Stack(
//                 children: [
//                   QRView(
//                     key: qrKey,
//                     onQRViewCreated: _onQRViewCreated,
//                     overlay: QrScannerOverlayShape(
//                       borderColor: Colors.greenAccent,
//                       borderWidth: 4,
//                       borderRadius: 12,
//                       borderLength: 40,
//                       cutOutSize: MediaQuery.of(context).size.width * 0.70,
//                     ),
//                   ),
//                   Positioned(
//                     top: 80,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: Text(
//                         "scanQrCode".tr(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 110,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: Text(
//                         "alignQrInsideFrame".tr(),
//                         style: const TextStyle(color: Colors.white70, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 40,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 26,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white12,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.white24),
//                           ),
//                           child: Text(
//                             "closeScanner".tr(),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) async {
//       if (_bottomSheetOpened) return;
//
//       if (scanData.code != null) {
//         _bottomSheetOpened = true;
//         controller.pauseCamera();
//
//         String code = scanData.code!;
//
//         try {
//           if (code.startsWith('{')) {
//             Map<String, dynamic> body = jsonDecode(code);
//             BarcodeModel data = BarcodeModel.fromJson(body);
//
//             if (data.type == "place") {
//               await _openSheet(QrDetailScreen(dt: body["url"].toString()));
//             } else if (data.type == "booking") {
//               await _openSheet(QrBookingScreen(dt: body["url"].toString()));
//             } else {
//               CenterDialog.errorDialog(context, "qrCodeNotSupported".tr());
//             }
//           } else {
//             await _openSheet(QrBookingScreen(dt: code));
//           }
//         } catch (e) {
//           CenterDialog.errorDialog(context, "qrCodeNotSupported".tr());
//         }
//
//         _bottomSheetOpened = false;
//         controller.resumeCamera();
//       }
//     });
//   }
//
//   Future<void> _openSheet(Widget screen) async {
//     await CupertinoScaffold.showCupertinoModalBottomSheet(
//       context: sheetContext,
//       builder: (ctx) => BlocProvider(
//         create: (_) => HomeBloc(homeRepository: HomeRepository()),
//         child: screen,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }





import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.greenAccent,
              borderWidth: 8,
              borderRadius: 12,
              borderLength: 30,
              cutOutSize: MediaQuery.of(context).size.width * 0.70,
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "scanQrCode".tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing || scanData.code == null) return;

      setState(() {
        _isProcessing = true;
      });

      await controller.pauseCamera();
      _handleScanResult(scanData.code!);
    });
  }

  void _handleScanResult(String code) async {
    try {
      final Map<String, dynamic> data = jsonDecode(code);
      final String id = data['id']?.toString() ?? "Noma'lum";
      final String token = data['token']?.toString() ?? "Noma'lum";

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Skaner natijasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID: $id", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Token: $token"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Xatolik"),
          content: const Text("QR kod formati noto'g'ri yoki ma'lumot o'qib bo'lmadi."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isProcessing = false;
    });
    await controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}