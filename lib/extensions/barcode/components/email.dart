import 'package:codereader/models/barcode_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';

List<BarcodeComponent> getEmailComponent(Email? email) {
  return [
    _getOpenEmailComponent(email),
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
}

BarcodeComponent _getOpenEmailComponent(Email? email) {
  return BarcodeComponent(
    title: "",
    content: "タップしてメールを作成",
    onTap: (context) {
      Navigator.of(context).pop();
      var urlBuilder = StringBuffer();
      urlBuilder.write("mailto:${email?.address ?? ""}");

      List<String> options = []; //オプションをいれておくためのリスト
      if (email?.subject != null) {
        options.add("subject=${email!.subject!}");
      }
      if (email?.body != null) {
        options.add("body=${email!.body!}");
      }

      var optionsString = options.join("&").toString(); //&でつなげる
      if (optionsString.isNotEmpty) {
        //もしオプションがあるなら?でつなぐ
        urlBuilder.write("?$optionsString");
      }
      var uri = Uri.encodeFull(urlBuilder.toString());
      launchUrlString(uri);
    },
  );
}
