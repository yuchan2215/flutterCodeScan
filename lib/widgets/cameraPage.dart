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

  List<Widget> wg = [];

  PanelController _pc = new PanelController();

  Widget getItemCard(Barcode element) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0,
          top: 3.0,
          right: 10.0,),
      child: Card(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(element.code ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  void update() {
    setState(() {
      _counts = codes.length;
      wg = [];
      codes.forEach((element) {
        wg.add(getItemCard(element));
      });
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
            controller: _pc,
            maxHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.bottom,
            panel: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    child: Center(
                      child: Text("$_counts件読み込みました"),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ...wg,
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: OutlinedButton(
                      onPressed: () {
                        _pc.close();
                      },
                      child: Container(
                          width: double.infinity,
                          child: Center(
                            child: Text("閉じる"),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            borderRadius: borderRadius,
          ),
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
