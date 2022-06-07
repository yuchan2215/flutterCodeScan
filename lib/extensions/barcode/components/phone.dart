import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

List<BarcodeComponent> getPhoneComponent(Phone? phone) {
  return [
    BarcodeComponent(
      title: "電話",
      content: phone?.number,
      isImportant: true,
      type: BarcodeComponentType.tel,
    ),
  ];
}
