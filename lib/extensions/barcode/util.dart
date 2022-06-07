import 'package:codereader/models/barcode_component.dart';
import 'package:codereader/widgets/camera/item.dart';
import 'package:kotlin_flavor/scope_functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'components.dart';
import 'type.dart';

extension BarcodeItemExt on Barcode {
  ///[PanelCard]にて表示される文字列
  ///[BarcodeComponent.isImportant]の文字列が表示される。
  String? get displayText {
    var items = components.where((component) => component.isImportant);
    if (items.length != 1) {
      return toJapanese;
    } else {
      return items.first.content;
    }
  }

  ///[PanelCard]に補助的に表示される文字列。
  ///
  ///[BarcodeComponentModel.isImportant]ではない
  ///[BarcodeComponentModel.content]が空ではない
  ///イベントのコンポーネントでないものを表示する。
  String? get getSubDisplayText {
    return components
        .where((element) =>
            !element.isImportant &&
            element.content != null &&
            !element.isEventComponent()) //条件の絞り込み
        .map<String>(
          (e) {
            //タイトルをつけるのであればつける。
            if (e.showTitleInResult) {
              return "[${e.title}]${e.content}";
            } else {
              return e.content ?? "";
            }
          },
        )
        .join("\n")
        //何も存在しないならNullとする。
        .let((items) {
          if (items.isEmpty) {
            return null;
          } else {
            return items;
          }
        });
  }
}
