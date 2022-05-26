import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:io';
import 'dart:developer';
import 'dart:math';

import '../app.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

final double edgeSize = 24.0;

class _CameraPageState extends State<CameraPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final BorderRadius borderRadius = BorderRadius.only(
    topLeft: Radius.circular(edgeSize),
    topRight: Radius.circular(edgeSize),
  );

  QRViewController? controller;

  List<Barcode> codes = [];
  int _counts = 0;

  void update() {
    setState(() {
      _counts = codes.length;
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("読み込み"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _buildQrView(context),
              ),
              SizedBox(
                height: 100.0 - edgeSize,
              ),
            ],
          ),
          SlidingUpPanel(
            panel: Center(
              child: Text("データ一覧はここに"),
            ),
            collapsed: Center(
                child: SafeArea(
              child: Text("$_counts件読み込みました"),
            )),
            borderRadius: borderRadius,
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scanArea = min(width, height) * 0.9;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    //データが存在するかどうか確認する。
    bool isExistData(Barcode barcode) {
      var readRaw = barcode.rawBytes?.join() ?? "";
      return codes
          .where((Barcode code) => (code.rawBytes?.join() ?? "") == readRaw)
          .isNotEmpty;
    }

    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      //もしデータがあるなら早期リターン
      if (isExistData(scanData)) return;

      codes.add(scanData);
      update();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}
