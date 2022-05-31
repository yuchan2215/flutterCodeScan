import 'package:codereader/pages/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class PanelCard extends StatelessWidget {
  final CamerapageState state;
  final Barcode barcode;
  final BuildContext context;
  PanelCard(this.state, this.barcode, this.context, {Key? key})
      : super(key: key);

  late final code = barcode.rawValue ?? "";
  final RegExp regex =
      RegExp(r"https?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 3.0,
        right: 10.0,
      ),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onLongPress: longPressEvent,
          onTap: tapEvent,
          child: cardItem(code),
        ),
      ),
    );
  }

  ///カードを長押しした時のイベント
  void longPressEvent() {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("クリップボードにコピーしました。")),
    );
  }

  ///カードをタップした時のイベント
  void tapEvent() {
    if (regex.hasMatch(code)) {
      showDialog(
        context: context,
        builder: (_) {
          return browserDialog();
        },
      );
    }
  }

  ///ブラウザを開く時のダイアログ
  AlertDialog browserDialog() {
    return AlertDialog(
      title: Row(children: const [
        Icon(Icons.open_in_browser),
        Text("ブラウザで開く"),
      ]),
      content: Text(code),
      actions: [
        TextButton(
          child: const Text("キャンセル"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("開く"),
          onPressed: () async {
            var uri = Uri.parse(code);
            if (!await canLaunchUrl(uri)) return;
            launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          },
        )
      ],
    );
  }

  ///カードの内容
  Padding cardItem(String code) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Text(code),
        ],
      ),
    );
  }
}
