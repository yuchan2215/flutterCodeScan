import 'package:flutter/material.dart';

import '../widgets/camera/panel.dart';

enum BarcodeComponentType {
  tel,
  email,
  url,
  other,
}

///読み取り結果の子要素のモデル。
class BarcodeComponent {
  ///タイトル
  final String title;

  ///コンテンツ ここがNullだと表示されない。
  final String? content;

  ///重要な要素。[SlideUpPanel]にて表示される。
  final bool isImportant;

  ///メモ要素。
  final bool isMemo;

  ///[SlideUpPanel]にて要素を表示するかどうか。
  final bool showTitleInResult;

  ///[BarcodeComponent]の種類。
  final BarcodeComponentType type;

  ///タップされた時のイベント
  final Function(BuildContext context)? onTap;

  ///イベントの[BarcodeComponent]であるかどうか。
  bool isEventComponent(){
    return onTap != null;
  }

  BarcodeComponent({
    required this.title,
    required this.content,
    this.isImportant = false,
    this.isMemo = false,
    this.showTitleInResult = false,
    this.type = BarcodeComponentType.other,
    this.onTap,
  });
}
