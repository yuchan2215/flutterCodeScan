import 'package:codereader/models/barcode_component.dart';
import 'package:codereader/widgets/camera/panel.dart';
import 'package:flutter/material.dart';
import 'package:kotlin_flavor/scope_functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../extensions/barcode/type.dart';
import '../../extensions/barcode/util.dart';

///[SlideUpPanel]に表示される[BarcodeComponent]
class PanelCard extends StatelessWidget {
  ///表示する[Barcode]
  final Barcode barcode;

  ///利用する[BuildContext]
  final BuildContext context;

  const PanelCard(this.barcode, this.context, {Key? key}) : super(key: key);

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
    Navigator.of(context).pushNamed("/result", arguments: barcode);
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
