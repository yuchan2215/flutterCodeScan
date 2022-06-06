import 'package:codereader/components/email.dart';
import 'package:codereader/components/geo.dart';
import 'package:codereader/extensions/barcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/barcode_component.dart';

final RegExp urlReg = RegExp(r"https?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+",
    caseSensitive: false);
final RegExp mailReg = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
    caseSensitive: false);

extension BarcodeComponentExt on Barcode {
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
          getGeoComponent(geoPoint),//開くボタン
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
          getEmailComponent(email),
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
}
