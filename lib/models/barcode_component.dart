import 'package:flutter/material.dart';

enum BarcodeComponentType {
  tel,
  email,
  url,
  other,
}

extension BarcodeComponentTypeExt on BarcodeComponentType {
  Icon? get getIcon {
    switch (this) {
      case BarcodeComponentType.email:
        return const Icon(Icons.mail);
      case BarcodeComponentType.tel:
        return const Icon(Icons.phone);
      case BarcodeComponentType.url:
        return const Icon(Icons.link);
      default:
        return null;
    }
  }
  String? get actionName {
    switch (this) {
      case BarcodeComponentType.email:
        return "メール";
      case BarcodeComponentType.tel:
        return "電話番号";
      case BarcodeComponentType.url:
        return "URL";
      default:
        return null;
    }

  }
}

class BarcodeComponent {
  final String title;
  final String? content;
  final bool isImportant;
  final bool isMemo;
  final bool showTitleInResult;
  final BarcodeComponentType type;
  BarcodeComponent({
    required this.title,
    required this.content,
    this.isImportant = false,
    this.isMemo = false,
    this.showTitleInResult = false,
    this.type = BarcodeComponentType.other,
  });
}
