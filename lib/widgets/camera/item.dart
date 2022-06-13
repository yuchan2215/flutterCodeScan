import 'package:codereader/models/barcode_component.dart';
import 'package:codereader/pages/camera.dart';
import 'package:codereader/widgets/camera/panel.dart';
import 'package:flutter/material.dart';
import 'package:kotlin_flavor/scope_functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../extensions/barcode/type.dart';
import '../../extensions/barcode/util.dart';
import '../settings/stop_timing.dart';

///[SlideUpPanel]に表示される[BarcodeComponent]
class PanelCard extends StatelessWidget {
  ///表示する[Barcode]
  final Barcode barcode;

  ///利用する[BuildContext]
  final BuildContext context;

  ///カメラページのステート
  final CameraPageState cameraState;

  const PanelCard(this.barcode, this.context, this.cameraState, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 3.0,
        right: 10.0,
      ),
      child: Card(
        child: InkWell(
          onTap: tapEvent,
          child: cardItem(),
        ),
      ),
    );
  }

  void tapEvent() {
    //もし結果画面でスキャンしないならカメラを止める
    if (!cameraState.stopTiming.scanOnResult) {
      cameraState.setCameraStatus(false);
    }
    Navigator.of(context)
        .pushNamed("/result", arguments: barcode)
        .then((value) {
      //戻って来た時、パネル画面でスキャンするならカメラを再開させる。
      if (cameraState.stopTiming.scanOnPanel) {
        cameraState.setCameraStatus(true);
      }
    });
  }

  Padding cardItem() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
          leading: Icon(barcode.icon),
          title: Text(barcode.displayText ?? ""),
          subtitle: barcode.getSubDisplayText?.let((it) {
            return Text(it);
          })),
    );
  }
}
