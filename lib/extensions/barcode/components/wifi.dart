import 'package:codereader/extensions/barcode/wifi_type.dart';
import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wifi_iot/wifi_iot.dart';

List<BarcodeComponent> getWifiComponent(WiFi? wifi) {
  return [
    BarcodeComponent(
        title: "接続する",
        content: "タップして接続する",
        onTap: (context) {
          WiFiForIoTPlugin.connect(wifi?.ssid ?? "",
              password: wifi?.password,
              security: wifi?.encryptionType.getNetworkSecurity ??
                  NetworkSecurity.NONE,
              joinOnce: false);
        }),
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
