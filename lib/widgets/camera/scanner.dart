import 'package:codereader/pages/camera.dart';
import 'package:codereader/widgets/camera/panel.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

///[CameraPage]にて表示される[MobileScanner]
class CameraView extends StatelessWidget {
  final CameraPageState state;

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
            onDetect: (barcode, _) => state.detect(barcode),
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
}
