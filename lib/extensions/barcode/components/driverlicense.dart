import 'package:codereader/models/barcode_component.dart';

List<BarcodeComponent> getDriverLicenseComponent() {
  return [
    BarcodeComponent(
        title: "未対応なフォーマット",
        content: "このQRコードの読み込みは対応していません。",
        isImportant: true)
  ];
}
