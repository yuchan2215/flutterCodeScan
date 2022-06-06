import 'package:codereader/models/barcode_component.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'barcode_components.dart';

extension EmailExt on Email {
  String? get typeText {
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
  String? get typeText {
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

extension BarcodeItemExt on Barcode{
  ///[PanelCard]にて表示される文字列
  String? get displayText {
    var items = components.where((element) => element.isImportant);
    if (items.length != 1) {
      return toJapanese;
    } else {
      return items.first.content;
    }
  }

  String? get getSubDisplayText {
    var text = components
        .where((element) =>
            !element.isImportant &&
            element.content != null &&
            element.onTap == null) //重要でないかつコンテンツがないもののみにする
        .map<String>(
      (e) {
        String title =
            e.showTitleInResult ? "[${e.title}] " : ""; //タイトルを表示するならタイトルを表示する。
        return "$title${e.content}";
      },
    ).join("\n");
    if (text.isEmpty) {
      return null;
    } else {
      return text;
    }
  }

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

class BarcodeItem {
  ///読み込まれた[Barcode]
  final Barcode barcode;

  ///利用する[BuildContext]
  final BuildContext context;

  ///[PanelCard]にて表示されるテキスト
  late final String display = barcode.displayText ?? "";

  ///[PanelCard]にて表示されるアイコン
  late final IconData icon = barcode.icon;

  ///[PanelCard]にて表示される説明文
  late final String? subDisplayText = barcode.getSubDisplayText;

  late final List<BarcodeComponent> components = barcode.components;

  BarcodeItem(this.barcode, this.context);

  Function nothingFunction = () {};
}
