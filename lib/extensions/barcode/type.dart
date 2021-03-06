import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contact;
import 'package:mobile_scanner/mobile_scanner.dart';

extension AddressExt on Address {
  contact.AddressLabel get label {
    switch (type) {
      case AddressType.work:
        return contact.AddressLabel.work;
      case AddressType.home:
        return contact.AddressLabel.home;
      default:
        return contact.AddressLabel.other;
    }
  }
}

extension EmailExt on Email {
  contact.EmailLabel get label {
    switch (type) {
      case EmailType.home:
        return contact.EmailLabel.home;
      case EmailType.work:
        return contact.EmailLabel.work;
      default:
        return contact.EmailLabel.home;
    }
  }

  String? get toJapanese {
    switch (type) {
      case EmailType.home:
        return "自宅:";
      case EmailType.work:
        return "勤務先:";
      default:
        return "";
    }
  }
}

extension PhoneExt on Phone {
  contact.PhoneLabel get label {
    switch (type) {
      case PhoneType.fax:
        return contact.PhoneLabel.faxHome;
      case PhoneType.home:
        return contact.PhoneLabel.home;
      case PhoneType.mobile:
        return contact.PhoneLabel.mobile;
      case PhoneType.work:
        return contact.PhoneLabel.work;
      default:
        return contact.PhoneLabel.other;
    }
  }

  String? get toJapanese {
    switch (type) {
      case PhoneType.fax:
        return "FAX";
      case PhoneType.home:
        return "自宅";
      case PhoneType.mobile:
        return "携帯";
      case PhoneType.work:
        return "仕事";
      default:
        return "";
    }
  }
}

extension BarcodeTypeExt on Barcode {
  ///[PanelCard]にて表示されるアイコン
  IconData get icon {
    switch (type) {
      case BarcodeType.text:
        return Icons.article;
      case BarcodeType.isbn:
      case BarcodeType.product:
        return Icons.category;
      case BarcodeType.wifi:
        return Icons.wifi;
      case BarcodeType.phone:
        return Icons.phone;
      case BarcodeType.email:
        return Icons.mail;
      case BarcodeType.url:
        return Icons.link;
      case BarcodeType.calendarEvent:
        return Icons.event;
      case BarcodeType.unknown:
        return Icons.question_mark;
      case BarcodeType.driverLicense:
        return Icons.directions_car_filled;
      case BarcodeType.contactInfo:
        return Icons.contacts;
      case BarcodeType.geo:
        return Icons.location_on;
      case BarcodeType.sms:
        return Icons.sms;
    }
  }

  String get toJapanese {
    switch (type) {
      case BarcodeType.phone:
        return "電話情報";
      case BarcodeType.isbn:
        return "ISBN";
      case BarcodeType.wifi:
        return "Wi-Fi";
      case BarcodeType.calendarEvent:
        return "イベント情報";
      case BarcodeType.text:
        return "テキスト";
      case BarcodeType.driverLicense:
        return "免許証情報";
      case BarcodeType.contactInfo:
        return "連絡先情報";
      case BarcodeType.url:
        return "URL";
      case BarcodeType.unknown:
        return "不明";
      case BarcodeType.product:
        return "製品";
      case BarcodeType.sms:
        return "SMS";
      case BarcodeType.geo:
        return "位置情報";
      case BarcodeType.email:
        return "メール";
    }
  }
}
