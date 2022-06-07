import 'dart:io';

import 'package:codereader/extensions/string_scope.dart';
import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

List<BarcodeComponent> getSMSComponent(SMS? sms) {
  return [
    if (sms?.message.emptyConvert != null)
      _getOpenSMSComponent(
          phoneNumber: sms?.phoneNumber ?? "", message: sms?.message ?? ""),
    BarcodeComponent(
      title: "電話番号",
      content: sms?.phoneNumber,
      isImportant: true,
      type: BarcodeComponentType.tel,
    ),
    BarcodeComponent(title: "本文", content: sms?.message),
  ];
}

BarcodeComponent _getOpenSMSComponent(
    {required String phoneNumber, required String message}) {
  return BarcodeComponent(
    title: "メッセージを送信する",
    content: "メッセージを送信する",
    onTap: (context) {
      if (Platform.isIOS) {
        var url = "sms:$phoneNumber&body=${Uri.decodeFull(message)}";
        launchUrl(Uri.parse(url));
      } else if (Platform.isAndroid) {
        var url = "sms:$phoneNumber?body=${Uri.decodeFull(message)}";
        launchUrl(Uri.parse(url));
      }
    },
  );
}
