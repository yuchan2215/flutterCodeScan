import 'package:codereader/pages/camera_panel_card_item.dart';
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
          ...advancedItems(),
        ],
      ),
    );
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
