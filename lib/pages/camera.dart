import 'package:after_layout/after_layout.dart';
import 'package:codereader/widgets/camera/panel.dart';
import 'package:codereader/widgets/camera/scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/camera/item.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage>
    with AfterLayoutMixin<CameraPage>, WidgetsBindingObserver {
  ///ライフサイクルをオブザーブする。
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //もしアプリが再開したのであれば、カメラの状態を復元する。
    if (state == AppLifecycleState.resumed) {
      setCameraStatus(cameraIsRunning);
    }
    super.didChangeAppLifecycleState(state);
  }

  ///[SlideUpPanel]のコントローラー
  final PanelController panelController = PanelController();

  ///[CameraView]のコントローラー
  final MobileScannerController mobileScannerController =
      MobileScannerController(autoResume: false);

  ///[SlideUpPanel]で使用するedgeSize
  final double edgeSize = 24.0;
  final double defaultPanelSize = 100.0;

  ///読み込まれた[Barcode]の一覧
  List<Barcode> codes = [];

  ///読み込まれた[Barcode]の数
  int counts = 0;

  ///[getSlidingUpPanel]に表示するウィジェット一覧
  List<Widget> widgets = [];

  ///[State]をアップデートする。
  void update() {
    setState(() {
      counts = codes.length;
      widgets = [];
      for (var element in codes) {
        widgets.add(
          PanelCard(element, context),
        );
      }
    });
  }

  ///カメラが実行中であるかという状態
  bool cameraIsRunning = true;

  void setCameraStatus(bool toStart) {
    //引数の値を変数に代入する
    cameraIsRunning = toStart;

    //もしカメラをつけるのであれば
    if (!mobileScannerController.isStarting && toStart) {
      mobileScannerController.start();
    } else if (!toStart) {
      //もし消すのであれば
      mobileScannerController.stop();
    }
  }

  ///もし画像のパスが渡されているのであれば、[MobileScannerController]に値を渡し、スキャンします。
  ///その後にスライドパネルを開きます
  @override
  void afterFirstLayout(BuildContext context) async {
    var obj = ModalRoute.of(context)?.settings.arguments;
    if (obj == null) return;
    if (obj is! XFile) return;
    String path = obj.path;
    await mobileScannerController.analyzeImage(path);
    panelController.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("読み込み"),
      ),
      body: Stack(
        children: [CameraView(this), SlideUpPanel(this, context)],
      ),
    );
  }
}
