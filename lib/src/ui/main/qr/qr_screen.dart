
import 'dart:convert';
import 'dart:io';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/widget/main/booking/booking_detail_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      final int? bookingId = data['id'] != null ? int.tryParse(data['id'].toString()) : null;

      if (bookingId == null) {
        if (mounted) {
          CenterDialog.errorDialog(context, "invalidQrCode".tr());
        }
        setState(() {
          _isProcessing = false;
        });
        await controller?.resumeCamera();
        return;
      }

      if (mounted) {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (bottomSheetContext) {
            return EasyLocalization(
              supportedLocales: const [
                Locale('en', 'EN'),
                Locale('ru', 'RU'),
                Locale('uz', 'UZ'),
              ],
              path: 'assets/translations',
              startLocale:
                  EasyLocalization.of(context)?.locale ??
                  const Locale('ru', 'RU'),
              fallbackLocale: const Locale('ru', 'RU'),
              child: BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: BookingDetailBottomSheet(
                  bookingId: bookingId,
                  isFromQrScan: true,
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        CenterDialog.errorDialog(context, "invalidQrCode".tr());
      }
    }

    setState(() {
      _isProcessing = false;
    });
    await controller?.resumeCamera();
  }

}