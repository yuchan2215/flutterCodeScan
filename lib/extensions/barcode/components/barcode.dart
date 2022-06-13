import 'package:codereader/models/barcode_component.dart';

List<BarcodeComponent> getBarcodeCommponent(String? displayValue) {
  return [
    BarcodeComponent(title: "Code", content: displayValue, isImportant: true)
  ];
}
