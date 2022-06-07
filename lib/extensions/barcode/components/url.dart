import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

List<BarcodeComponent> getUrlComponent(UrlBookmark? url) {
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
}
