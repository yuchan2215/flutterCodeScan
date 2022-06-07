import 'package:mobile_scanner/mobile_scanner.dart';

import './components/barcode.dart';
import './components/calendar.dart';
import './components/contact.dart';
import './components/driverLicense.dart';
import './components/email.dart';
import './components/geo.dart';
import './components/phone.dart';
import './components/sms.dart';
import './components/text.dart';
import './components/url.dart';
import './components/wifi.dart';
import '../../models/barcode_component.dart';

extension BarcodeComponentExt on Barcode {
  ///[Barcode]の成分一覧を確認します。
  List<BarcodeComponent> get components {
    switch (type) {
      case BarcodeType.url:
        return getUrlComponent(url);

      case BarcodeType.geo:
        return getGeoComponent(geoPoint);

      case BarcodeType.email:
        return getEmailComponent(email);

      case BarcodeType.text:
        return getTextComponents(displayValue);

      case BarcodeType.isbn:
      case BarcodeType.product:
        return getBarcodeCommponent(displayValue);

      case BarcodeType.wifi:
        return getWifiComponent(wifi);

      case BarcodeType.phone:
        return getPhoneComponent(phone);

      case BarcodeType.sms:
        return getSMSComponent(sms);

      case BarcodeType.calendarEvent:
        return getCalendarComponent(calendarEvent);

      case BarcodeType.contactInfo:
        return getContactComponents(contactInfo);

      case BarcodeType.driverLicense:
        return getDriverLicenseComponent();

      case BarcodeType.unknown:
        return [];
    }
  }
}
