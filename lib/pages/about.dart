import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mono_kit/widgets/filled_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPageState extends StatefulWidget {
  const AboutPageState({Key? key}) : super(key: key);

  @override
  State<AboutPageState> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPageState>
    with AfterLayoutMixin<AboutPageState> {
  String appName = "読み込み中";
  String appVersion = "読み込み中";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("このアプリについて"),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text("アプリ名"),
              subtitle: Text(appName),
            ),
            ListTile(
              title: const Text("バージョン"),
              subtitle: Text(appVersion),
            ),
            //ライセンス確認ボタン
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(3),
              child: FilledButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showLicensePage(context: context);
                },
                child: const Text("ライセンス情報を確認"),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: const Text("アプリのアイコンは ICON BOX 様の画像を利用しております。"),
            )
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    var packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
    });
  }
}
