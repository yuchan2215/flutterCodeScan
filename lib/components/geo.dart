import 'package:codereader/models/barcode_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


///[GeoPoint]を開くための[BarcodeComponent]
BarcodeComponent getGeoComponent(GeoPoint? geoPoint) {
  var coords = Coords(geoPoint?.latitude ?? 0, geoPoint?.longitude ?? 0);
  return BarcodeComponent(
    title: "",
    content: "タップして地図を開く",
    onTap: (context) async {
      Navigator.of(context).pop();
      //利用できるマップ一覧を取得
      var maps = await MapLauncher.installedMaps;
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text("地図アプリを選択"),
          //マップごとにボタンを作成
          actions: maps
              .map((e) => CupertinoActionSheetAction(
                  onPressed: () {
                    //マップを開く
                    Navigator.of(context).pop();
                    e.showMarker(coords: coords, title: "読み込まれた地点");
                  },
                  child: Text(e.mapName)))
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("キャンセル"),
          ),
        ),
      );
    },
  );
}
