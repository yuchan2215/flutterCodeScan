import 'package:codereader/extensions/barcode/type.dart';
import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

List<BarcodeComponent> getContactComponents(ContactInfo? contactInfo) {
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
              title: "電話 ${e.toJapanese}",
              content: e.number,
              type: BarcodeComponentType.tel,
            )) ??
        [],
    ...contactInfo?.emails.map((e) => BarcodeComponent(
              title: "メール ${e.toJapanese}",
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
}
