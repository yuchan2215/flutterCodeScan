import 'package:codereader/extensions/barcode/components.dart';
import 'package:codereader/widgets/result/component_item.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/additional_information.dart';

class ResultPageState extends StatefulWidget {
  const ResultPageState({Key? key}) : super(key: key);

  @override
  State<ResultPageState> createState() => _ResultPageStateState();
}

class _ResultPageStateState extends State<ResultPageState> {
  //渡されてきたオブジェクト
  late final Barcode item =
      ModalRoute.of(context)?.settings.arguments as Barcode;

  ///追加情報のリスト
  late List<AdditionalInformation> addItems = [
    AdditionalInformation(
      title: "RawValue",
      value: item.rawValue,
    ),
    AdditionalInformation(
      title: "RawBytes",
      value: item.rawBytes?.join("").toString(),
    ),
    AdditionalInformation(
      title: "DisplayValue",
      value: item.displayValue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          //もしメモであるならメモとして表示する
          if (e.isMemo) {
            return ListTile(
              leading: const Icon(Icons.info),
              title: Text(e.content!),
            );
          } else {
            return ComponentWidget(component: e);
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
