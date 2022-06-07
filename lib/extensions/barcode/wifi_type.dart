import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wifi_iot/wifi_iot.dart';

extension WifiExt on EncryptionType {
  NetworkSecurity get getNetworkSecurity {
    switch (this) {
      case EncryptionType.none:
      case EncryptionType.open:
        return NetworkSecurity.NONE;
      case EncryptionType.wep:
        return NetworkSecurity.WEP;
      case EncryptionType.wpa:
        return NetworkSecurity.WPA;
    }
  }
}
