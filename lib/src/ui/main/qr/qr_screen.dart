import 'dart:convert';
import 'dart:io';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/model/api/main/qr/barcode_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/ui/main/qr/screen/qr_booking_screen.dart';
import 'package:bandu_business/src/ui/main/qr/screen/qr_detail_screen.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  bool _bottomSheetOpened = false;

  late BuildContext sheetContext; // <<< MUHIM

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) {
          sheetContext = context;

          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.greenAccent,
                      borderWidth: 4,
                      borderRadius: 12,
                      borderLength: 40,
                      cutOutSize: MediaQuery.of(context).size.width * 0.70,
                    ),
                  ),

                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "scanQrCode".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 110,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "alignQrInsideFrame".tr(),
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            "closeScanner".tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (_bottomSheetOpened) return;

      result = scanData;

      if (result != null) {
        _bottomSheetOpened = true;
        controller.pauseCamera();
        print("result ${result!.code}");
        BarcodeModel data = BarcodeModel.fromJson(
          jsonDecode(result!.code.toString()),
        );

        if (data.type == "place") {
          await CupertinoScaffold.showCupertinoModalBottomSheet(
            context: sheetContext,
            builder: (ctx) => BlocProvider(
              create: (_) => HomeBloc(homeRepository: HomeRepository()),
              child: QrDetailScreen(
                dt: (jsonDecode(result!.code.toString())["url"].toString()),
              ),
            ),
          );
        } else if (data.type == "booking") {
          print("booking: ${result!.code}");
          await CupertinoScaffold.showCupertinoModalBottomSheet(
            context: sheetContext,
            builder: (ctx) => BlocProvider(
              create: (_) => HomeBloc(homeRepository: HomeRepository()),
              child: QrBookingScreen(
                dt: (jsonDecode(result!.code.toString())["url"].toString()),
              ),
            ),
          );
        } else {
          CenterDialog.errorDialog(context, "qrCodeNotSupported".tr());
        }

        _bottomSheetOpened = false;
        controller.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
