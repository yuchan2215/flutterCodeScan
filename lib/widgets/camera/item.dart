import 'package:codereader/pages/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../extensions/barcode.dart';

class PanelCard extends StatelessWidget {
  final CamerapageState state;
  final Barcode barcode;
  final BuildContext context;
  late final BarcodeItem item = BarcodeItem(barcode, context);
  PanelCard(this.state, this.barcode, this.context, {Key? key})
      : super(key: key);
  final RegExp regex =
      RegExp(r"https?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+");

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
          onLongPress: longPressEvent,
          onTap: tapEvent,
          child: cardItem(),
        ),
      ),
    );
  }
  void tapEvent(){
            Navigator.of(context).pushNamed("/result",arguments: item);
  }
  ///カードを長押しした時のイベント
  void longPressEvent() {
    Clipboard.setData(ClipboardData(text: barcode.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("クリップボードにコピーしました。")),
    );
  }

  ///カードの内容
  Padding cardItem() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        leading: Icon(item.icon),
        title: Text(item.display),
        subtitle:
            item.subDisplayText != null ? Text(item.subDisplayText!) : null,
      ),
    );
  }
}
