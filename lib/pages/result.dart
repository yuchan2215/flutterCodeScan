import 'package:codereader/pages/camera_panel_card_item.dart';
import 'package:flutter/material.dart';

class ResultPageState extends StatefulWidget{

  const ResultPageState({Key? key}): super(key: key);

  @override
  State<ResultPageState> createState() => _ResultPageStateState();
}

class _ResultPageStateState extends State<ResultPageState> {
  late final BarcodeItem? item;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    if(args is! BarcodeItem){
      Navigator.of(context).pop();}
    item = args as BarcodeItem;
    return Scaffold(
      appBar: AppBar(
        title: const Text("読取結果"),
      ),
    );
  }
}