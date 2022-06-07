import 'package:codereader/pages/camera.dart';
import 'package:flutter/material.dart';
import 'package:mono_kit/widgets/filled_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

///[CameraPage]にて表示される[SlidingUpPanel]
class SlideUpPanel extends StatelessWidget {
  ///[State]
  final CameraPageState state;

  ///使用する[BuildContext]
  final BuildContext context;

  ///[SlideUpPanel]の丸み
  late final BorderRadius borderRadius = BorderRadius.only(
    topLeft: Radius.circular(state.edgeSize),
    topRight: Radius.circular(state.edgeSize),
  );

  SlideUpPanel(this.state, this.context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (key, builder) => SlidingUpPanel(
        controller: state.panelController,
        maxHeight: builder.maxHeight,
        panel: SafeArea(
          child: Column(
            children: <Widget>[
              _loadCountBox(),
              _loadItemListView(),
              _bottomButtons(),
            ],
          ),
        ),
        borderRadius: borderRadius,
        onPanelOpened: () {
          //パネルを開けたらカメラをストップさせる
          state.mobileScannerController.stop();
        },
        onPanelClosed: () {
          //パネルを閉めたらカメラをスタートさせる
          state.mobileScannerController.start();
        },
      ),
    );
  }

  ///読み込んだアイテムの[ListView]
  Expanded _loadItemListView() {
    return Expanded(
      child: ListView(
        children: [
          ...state.widgets,
        ],
      ),
    );
  }

  ///読み込んだアイテムの件数
  SizedBox _loadCountBox() {
    return SizedBox(
      height: state.defaultPanelSize,
      child: Center(
        child: Text("${state.counts}件読み込みました"),
      ),
    );
  }

  ///下部のボタン一覧
  Widget _bottomButtons() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10.0,
      ),
      child: Row(
        children: [
          _deleteButton(),
          const SizedBox(
            width: 10.0,
          ),
          _closeButton()
        ],
      ),
    );
  }

  ///閉じるボタン
  Expanded _closeButton() {
    return Expanded(
      //閉じるボタン
      flex: 2,
      child: FilledTonalButton(
        onPressed: () {
          state.panelController.close();
        },
        child: const Text("閉じる"),
      ),
    );
  }

  ///削除ボタン
  Expanded _deleteButton() {
    return Expanded(
      // 削除ボタン
      flex: 1,
      child: FilledTonalButton(
        style: FilledTonalButton.styleFrom(
          primary: Theme.of(context).errorColor,
        ),
        onPressed: () {
          //からにする
          state.codes = [];
          state.update();
        },
        child: const Text(
          "全て削除",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
