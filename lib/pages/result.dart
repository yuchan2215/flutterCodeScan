import 'package:codereader/extensions/barcode.dart';
import 'package:codereader/models/barcode_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPageState extends StatefulWidget {
  const ResultPageState({Key? key}) : super(key: key);

  @override
  State<ResultPageState> createState() => _ResultPageStateState();
}

class AdditionalInformation {
  AdditionalInformation({
    required this.title,
    required this.value,
    this.isExpanded = false,
  });
  String title;
  String? value;
  bool isExpanded;
}

class _ResultPageStateState extends State<ResultPageState> {
  late final Object? argObject = ModalRoute.of(context)?.settings.arguments;

  late BarcodeItem item = argObject as BarcodeItem;

  late List<AdditionalInformation> addItems = [
    AdditionalInformation(title: "RawValue", value: item.barcode.rawValue),
    AdditionalInformation(
        title: "RawBytes", value: item.barcode.rawBytes?.join("").toString()),
    AdditionalInformation(
        title: "DisplayValue", value: item.barcode.displayValue),
  ];

  @override
  Widget build(BuildContext context) {
    if (argObject is! BarcodeItem) {
      Navigator.of(context).pop();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("読取結果"),
      ),
      body: ListView(
        children: [
          ...scanedItems(),
          ...advancedItems(),
        ],
      ),
    );
  }

  List<Widget> scanedItems() {
    return [
      ...item.components.where((e) => e.content != null).map(
        (e) {
          if (e.isMemo) {
            //メモの時はアイコンのみにする
            return ListTile(
              leading: const Icon(Icons.info),
              title: Text(e.content!),
            );
          } else {
            //メモでないときはアイコンにする。
            return Card(
              margin: const EdgeInsets.all(16),
              child: InkWell(
                onLongPress: () {
                  tapEvent(e: e);
                },
                onTap: () {
                  tapEvent(e: e);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 5, top: 5, bottom: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${e.title}:",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16.0, top: 8.0),
                        child: Text(
                          e.content!,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    ];
  }

  void tapEvent({required BarcodeComponent e}) {
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
            child: const Text("開く"),
          )
        ];
      case BarcodeComponentType.url:
        return [
          CupertinoActionSheetAction(
            onPressed: () {
              launchUrl(Uri.parse(component.content!),
                  mode: LaunchMode.externalApplication);
            },
            child: const Text("開く"),
          )
        ];
      default:
        return [];
    }
  }

  List<Widget> advancedItems() {
    return [
      const ListTile(
        title: Text("高度な情報"),
        leading: Icon(Icons.info),
      ),
      ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            addItems[panelIndex].isExpanded = !isExpanded;
          });
        },
        children: addItems.map<ExpansionPanel>((i) {
          return ExpansionPanel(
            headerBuilder: ((context, isExpanded) {
              return InkWell(
                child: ListTile(title: Text(i.title)),
                onTap: () {
                  setState(() {
                    i.isExpanded = !i.isExpanded;
                  });
                },
              );
            }),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(i.value ?? ""),
            ),
            isExpanded: i.isExpanded,
          );
        }).toList(),
      ),
    ];
  }
}
