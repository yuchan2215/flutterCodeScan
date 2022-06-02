import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'camera_panel_card.dart';


extension BarcodeTypeExt on Barcode{
  ///[PanelCard]にて表示される文字列
  String? get displayText{
    switch(type){
      case BarcodeType.text:
        return displayValue;
      case BarcodeType.url:
        return url?.url;
      case BarcodeType.email:
        return email?.address;
      case BarcodeType.calendarEvent:
        return calendarEvent?.description;
      case BarcodeType.contactInfo:
        if (contactInfo?.name?.formattedName != null) {
          return contactInfo?.name?.formattedName;
        } else {
          return "名刺データ";
        }
      case BarcodeType.phone:
        return phone?.number;
      case BarcodeType.wifi:
        return wifi?.ssid;
      case BarcodeType.isbn:
      case BarcodeType.unknown:
      case BarcodeType.product:
        return displayValue;
      case BarcodeType.sms:
        return sms?.phoneNumber ?? "テキストメッセージデータ";
      case BarcodeType.geo:
        return "位置データ";
      case BarcodeType.driverLicense:
        return driverLicense?.firstName ?? "免許証データ";
    }
  }
  ///[PanelCard]にて表示されるアイコン
  IconData get icon{
    switch(type){
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
}
class BarcodeItem {
  ///読み込まれた[Barcode]
  final Barcode barcode;
  ///利用する[BuildContext]
  final BuildContext context;

  ///[PanelCard]にて表示されるテキスト
  late final String display = barcode.displayText ?? "";
  ///[PanelCard]にて表示されるアイコン
  late final IconData icon = barcode.icon;

  BarcodeItem(this.barcode, this.context);

  
  Function nothingFunction = () {};
}
