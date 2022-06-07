import 'package:codereader/models/barcode_component.dart';

final RegExp urlReg = RegExp(r"https?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+",
    caseSensitive: false);
final RegExp mailReg = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
    caseSensitive: false);

List<BarcodeComponent> getTextComponents(String? displayValue) {
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
}
