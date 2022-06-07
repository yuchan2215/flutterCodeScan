import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

List<BarcodeComponent> getWifiComponent(WiFi? wifi) {
  return [
    BarcodeComponent(
      title: "SSID",
      content: wifi?.ssid,
      isImportant: true,
    ),
    BarcodeComponent(
      title: "Password",
      content: wifi?.password,
      showTitleInResult: true,
    ),
    BarcodeComponent(
      title: "暗号化種類",
      content: wifi?.encryptionType.name,
      showTitleInResult: true,
    ),
  ];
}
