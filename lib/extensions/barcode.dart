import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final RegExp urlReg = RegExp(
    r"https?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+RR",
    caseSensitive: false);
final RegExp mailReg = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
    caseSensitive: false);

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
        return "(FAX)";
      case PhoneType.home:
        return "(自宅)";
      case PhoneType.mobile:
        return "(携帯)";
      case PhoneType.work:
        return "(仕事)";
      default:
        return "";
    }
  }
}

extension BarcodeTypeExt on Barcode {
  ///[PanelCard]にて表示される文字列
  String? get displayText {
    switch (type) {
      case BarcodeType.text:
        return displayValue;
      case BarcodeType.url:
        return url?.url;
      case BarcodeType.email:
        return email?.address;
      case BarcodeType.calendarEvent:
        return calendarEvent?.summary;
      case BarcodeType.contactInfo:
        if (contactInfo?.name?.formattedName != null) {
          return contactInfo?.name?.formattedName;
        } else {
          return "連絡先データ";
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
        return sms?.phoneNumber ?? "SMSを作成";
      case BarcodeType.geo:
        return "位置データ";
      case BarcodeType.driverLicense:
        return null;
    }
  }

  String? get getSubDisplayText {
    switch (type) {
      case BarcodeType.url:
        return url?.title;
      case BarcodeType.calendarEvent:
        return calendarEvent?.description;
      case BarcodeType.email:
        String? title = email?.subject;
        String? content = email?.body;
        String? displayTitle = (title == null) ? null : "件名: $title}";
        String? displayContent = (title == null) ? null : "本文: $content";
        //もしどちらも存在するなら
        if (displayTitle != null && displayContent != null) {
          return "$displayText\n$displayContent";
          //もしどちらも存在しないなら
        } else if (displayTitle == null && displayContent == null) {
          return "タップして空メールを作成";
          //どちらかが存在するなら
        } else {
          return "$displayText$displayContent";
        }
      case BarcodeType.wifi:
        return "暗号化方式:${wifi?.encryptionType.name.toUpperCase()}";
      case BarcodeType.sms:
        return sms?.message;
      case BarcodeType.contactInfo:
        var buffer = StringBuffer();
        //所属
        if (contactInfo?.organization?.isNotEmpty ?? false) {
          buffer.write("\n所属：${contactInfo!.organization!}");
        }
        //役職
        if (contactInfo?.title?.isNotEmpty ?? false) {
          buffer.write("\n役職：${contactInfo!.title}");
        }
        //電話
        if (contactInfo?.phones?.isNotEmpty ?? false) {
          buffer.write("\n電話：");
          buffer.write(contactInfo!.phones!
              .map((e) => "${e.typeText}${e.number}")
              .join(" \n "));
        }
        //メール
        if (contactInfo?.emails.isNotEmpty ?? false) {
          buffer.write("\nメール：");
          buffer.write(contactInfo!.emails
              .map((e) => "${e.typeText}${e.address}")
              .join(" \n "));
        }
        //住所
        if (contactInfo?.addresses.isNotEmpty ?? false) {
          buffer.write("\n住所：\n");
          buffer.write(contactInfo!.addresses
              .map(
                (e) => e.addressLines.reversed.join("\n"),
              )
              .toList()
              .join("\n\n"));
        }
        //URL
        if (contactInfo?.urls?.isNotEmpty ?? false) {
          buffer.write("\nURL：");
          buffer.write(contactInfo!.urls!.join(" \n "));
        }
        //最初の\nを消す。
        if (buffer.isNotEmpty) {
          return buffer.toString().replaceFirst("\n", "");
        } else {
          return null;
        }
      case BarcodeType.driverLicense:
        return null; //サポート対象外
      case BarcodeType.text:
        var urlMatches = urlReg.allMatches(displayValue ?? "");
        var emailMatches = mailReg.allMatches(displayValue ?? "");
        var allMatches = urlMatches.toList()..addAll(emailMatches);

        var textList = allMatches.map((e) => e.group(0)).toList();
        if (emailMatches.isNotEmpty) {
          textList.insert(0, "${emailMatches.length}件のメールアドレスが検出されました");
        }
        if (urlMatches.isNotEmpty) {
          textList.insert(0, "${urlMatches.length}件のURLが検出されました");
        }
        var text = textList.join("\n");
        return urlMatches.isEmpty ? null : text;
      case BarcodeType.product:
      case BarcodeType.phone:
      case BarcodeType.isbn:
      case BarcodeType.geo:
      case BarcodeType.unknown:
        return null;
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

  BarcodeItem(this.barcode, this.context);

  Function nothingFunction = () {};
}
