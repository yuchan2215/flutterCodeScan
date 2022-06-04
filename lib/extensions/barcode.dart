import 'package:codereader/models/barcode_component.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';

final RegExp urlReg = RegExp(r"https?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+",
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
  ///[PanelCard]にて表示される文字列
  String? get displayText {
    var items = components.where((element) => element.isImportant);
    if (items.length != 1) {
      return toJapanese;
    } else {
      return items.first.content;
    }
  }

  ///[Barcode]の成分一覧を確認します。
  List<BarcodeComponent> get components {
    switch (type) {
      case BarcodeType.url:
        //URL
        return [
          BarcodeComponent(
            title: "Title",
            content: url?.title,
          ),
          BarcodeComponent(
            title: "URL",
            content: url?.url,
            isImportant: true,
            type: BarcodeComponentType.url,
          ),
        ];
      case BarcodeType.geo:
        //GEO
        return [
          BarcodeComponent(
            title: "経線",
            content: geoPoint?.longitude?.toString(),
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "緯線",
            content: geoPoint?.latitude?.toString(),
            showTitleInResult: true,
          ),
        ];
      case BarcodeType.email:
        //Email
        return [
          BarcodeComponent(
            title: "宛先",
            content: email?.address,
            isImportant: true,
            type: BarcodeComponentType.email,
          ),
          BarcodeComponent(
            title: "件名",
            content: email?.subject,
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "本文",
            content: email?.body,
            showTitleInResult: true,
          ),
        ];
      //テキスト
      case BarcodeType.text:
        var urlMatches = urlReg.allMatches(displayValue ?? "");
        var emailMatches = mailReg.allMatches(displayValue ?? "");
        List<BarcodeComponent> items = [
          BarcodeComponent(
              title: "テキスト", content: displayValue, isImportant: true)
        ];
        if (emailMatches.isNotEmpty) {
          //メールアドレスが含まれるなら要素を追加していく
          items.addAll([
            BarcodeComponent(
                title: "見つかった件数",
                content: "${emailMatches.length}件のメールアドレスが検出されました",
                isMemo: true),
            ...emailMatches.map((e) => BarcodeComponent(
                  title: "メールアドレス",
                  content: e.group(0),
                  type: BarcodeComponentType.email,
                ))
          ]);
        }
        if (urlMatches.isNotEmpty) {
          //URLが含まれるなら要素を追加していく
          items.addAll([
            BarcodeComponent(
                title: "見つかった件数",
                content: "${urlMatches.length}件のURLが検出されました",
                isMemo: true),
            ...urlMatches.map((e) => BarcodeComponent(
                  title: "URL",
                  content: e.group(0),
                  type: BarcodeComponentType.url,
                ))
          ]);
        }
        return items;
      case BarcodeType.isbn:
        return [
          BarcodeComponent(
              title: "ISBN", content: displayValue, isImportant: true),
        ];
      case BarcodeType.wifi:
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
      case BarcodeType.product:
        return [
          BarcodeComponent(
              title: "PRODUCTCODE", content: displayValue, isImportant: true),
        ];
      case BarcodeType.phone:
        return [
          BarcodeComponent(
            title: "電話",
            content: displayValue,
            isImportant: true,
            type: BarcodeComponentType.tel,
          ),
        ];
      case BarcodeType.sms:
        return [
          BarcodeComponent(
            title: "電話番号",
            content: sms?.phoneNumber,
            isImportant: true,
            type: BarcodeComponentType.tel,
          ),
          BarcodeComponent(title: "本文", content: sms?.message),
        ];
      case BarcodeType.calendarEvent:
        initializeDateFormatting("ja");

        var formatter = DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
        var start = calendarEvent?.start;
        var end = calendarEvent?.end;
        var formattedStart = start == null ? null : formatter.format(start);
        var formattedEnd = end == null ? null : formatter.format(end);

        return [
          BarcodeComponent(
              title: "用件",
              content: calendarEvent?.description,
              isImportant: true),
          BarcodeComponent(
            title: "概要",
            content: calendarEvent?.summary,
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "主催者",
            content: calendarEvent?.organizer,
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "ステータス",
            content: calendarEvent?.status,
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "場所",
            content: calendarEvent?.location,
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "開始日時",
            content: formattedStart,
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "終了日時",
            content: formattedEnd,
            showTitleInResult: true,
          ),
        ];
      case BarcodeType.contactInfo:
        return [
          BarcodeComponent(
              title: "名前",
              content: contactInfo?.name?.formattedName,
              isImportant: true),
          BarcodeComponent(
            title: "所属",
            content: contactInfo?.organization,
            showTitleInResult: true,
          ),
          BarcodeComponent(
            title: "役職",
            content: contactInfo?.title,
            showTitleInResult: true,
          ),
          ...contactInfo?.phones?.map((e) => BarcodeComponent(
                    title: "電話 ${e.typeText}",
                    content: e.number,
                    type: BarcodeComponentType.tel,
                  )) ??
              [],
          ...contactInfo?.emails.map((e) => BarcodeComponent(
                    title: "メール ${e.typeText}",
                    content: e.address,
                    type: BarcodeComponentType.email,
                  )) ??
              [],
          ...contactInfo?.addresses.map((e) => BarcodeComponent(
                  title: "住所", content: e.addressLines.join(""))) ??
              [],
          ...contactInfo?.urls?.map((e) => BarcodeComponent(
                    title: "URL",
                    content: e,
                    type: BarcodeComponentType.url,
                  )) ??
              [],
        ];
      case BarcodeType.driverLicense:
        return [
          BarcodeComponent(
              title: "未対応なフォーマット",
              content: "このQRコードの読み込みは対応していません。",
              isImportant: true)
        ];
      case BarcodeType.unknown:
        return [];
    }
  }

  String? get getSubDisplayText {
    var text = components
        .where((element) =>
            !element.isImportant &&
            element.content != null) //重要でないかつコンテンツがないもののみにする
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
