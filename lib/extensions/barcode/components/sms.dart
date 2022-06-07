import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

List<BarcodeComponent> getSMSComponent(SMS? sms) {
  return [
    BarcodeComponent(
      title: "電話番号",
      content: sms?.phoneNumber,
      isImportant: true,
      type: BarcodeComponentType.tel,
    ),
    BarcodeComponent(title: "本文", content: sms?.message),
  ];
}
