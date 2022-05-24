import 'package:flutter/material.dart';

import '../app.dart';

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Container()),
            getCard(
              title: "カメラから読み込む",
              description: "カメラを起動して撮影した画像から、コードを読み取ります。",
              icon: Icons.camera_alt_outlined,
            ),
            getCard(
              title: "ギャラリーから読み込む",
              description: "ギャラリーから画像を選択された画像から、コードを読み取ります。",
              icon: Icons.image_search,
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Card getCard(
      {required String title,
      required String description,
      required IconData icon}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 100.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50.0,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      description,
                      softWrap: true,
                    ),
                    const Divider(),
                    Container(
                      width: double.infinity,
                      child: OutlinedButton( //参考：https://zenn.dev/enoiu/articles/6b754d37d5a272#elevatedbutton%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6
                        style: ElevatedButton.styleFrom(
                          onPrimary: Theme.of(context).colorScheme.onPrimary,
                          primary: Theme.of(context).colorScheme.primary,
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () {},
                        child: const Text("開く"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
