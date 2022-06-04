import 'package:codereader/extensions/barcode.dart';
import 'package:flutter/material.dart';

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
          if (e.isMemo) { //メモの時はアイコンのみにする
            return ListTile(
              leading: const Icon(Icons.info),
              title: Text(e.content!),
            );
          } else { //メモでないときはアイコンにする。
            return Card(
              margin: const EdgeInsets.all(16),
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
            );
          }
        },
      ),
    ];
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
