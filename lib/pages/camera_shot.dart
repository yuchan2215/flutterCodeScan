import 'package:codereader/pages/camera.dart';
import 'package:codereader/pages/camera_panel.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraView extends StatelessWidget {
  final CamerapageState state;
  const CameraView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: state.mobileScannerController,
            allowDuplicates: true,
            //検出時の処理
            onDetect: (barcode, args) async {
              if (kDebugMode) {
                print(barcode.displayValue);
              }
              if (barcode.rawBytes == null) return; //もしデータがNullな早期リターン
              if (isExistData(barcode)) return; //もしデータが存在するなら早期リターン
              state.codes.add(barcode); //コードを追加する
              state.update(); //アップデートする。
            },
          ),
        ),
        spacer(),
      ],
    );
  }

  ///[SlideUpPanel]で隠れる場所をスペースにする。
  SizedBox spacer() {
    return SizedBox(
      height: state.defaultPanelSize - state.edgeSize,
    );
  }

  ///データが存在するかどうか
  bool isExistData(Barcode barcode) {
    var readRaw = barcode.rawBytes?.join(""); //Stringに変換する
    return state.codes
        .where((Barcode code) => code.rawBytes?.join("") == readRaw)
        .isNotEmpty;
  }
}
