import 'package:codereader/models/barcode_component.dart';
import 'package:codereader/pages/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

///[BarcodeComponent]を[ResultPageState]で表示するための[Widget]
class ComponentWidget extends StatelessWidget {
  final BarcodeComponent component;

  const ComponentWidget({Key? key, required this.component}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onLongPress: () {
          _tap(context);
        },
        onTap: () {
          _tap(context);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 5, top: 5, bottom: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //左寄せにする
            children: [
              ///onTapでないのであれば、タイトルを表示する
              if (component.onTap == null)
                Text(
                  "${component.title}:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey),
                ),
              //本文を表示する
              Container(
                margin: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(
                  component.content!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///[ComponentWidget]がタップされた時に呼び出される。
  void _tap(BuildContext context) {
    //Tapイベントがあればそれを実行し、無いのであればポップアップを開く。
    if (component.onTap == null) {
      _showPopup(e: component, context: context);
    } else {
      component.onTap!.call(context);
    }
  }

  ///ポップアップを表示する。
  void _showPopup(
      {required BarcodeComponent e, required BuildContext context}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(e.content!),
        actions: [
          //コピーボタン
          CupertinoActionSheetAction(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: e.content!),
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("クリップボードにコピーしました。")),
              );
            },
            child: const Text("コピー"),
          ),
          //共有ボタン
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              Share.share("${e.content!} ");
            },
            child: const Text("共有"),
          ),
          //開くボタン
          ...getButtons(e),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("キャンセル"),
        ),
      ),
    );
  }

  ///[BarcodeComponentType]ごとに[CupertinoActionSheetAction]を作成する
  List<CupertinoActionSheetAction> getButtons(BarcodeComponent component) {
    switch (component.type) {
      case BarcodeComponentType.tel:
        return [
          CupertinoActionSheetAction(
            onPressed: () {
              launchUrl(Uri.parse("tel:${component.content!}"));
            },
            child: const Text("電話"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              launchUrl(Uri.parse("sms:${component.content!}"));
            },
            child: const Text("SMS"),
          )
        ];
      case BarcodeComponentType.email:
        return [
          CupertinoActionSheetAction(
            onPressed: () {
              launchUrl(Uri.parse("mailto:${component.content!}"));
            },
            child: const Text("メールを作成"),
          )
        ];
      case BarcodeComponentType.url:
        return [
          CupertinoActionSheetAction(
            onPressed: () {
              launchUrl(Uri.parse(component.content!),
                  mode: LaunchMode.externalApplication);
            },
            child: const Text("ブラウザで開く"),
          )
        ];
      default:
        return [];
    }
  }
}
