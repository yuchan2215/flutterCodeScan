import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mono_kit/mono_kit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  CamerapageState createState() => CamerapageState();
}

const double edgeSize = 24.0;

class CamerapageState extends State<CameraPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final BorderRadius borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(edgeSize),
    topRight: Radius.circular(edgeSize),
  );

  List<Barcode> codes = [];
  int _counts = 0;

  List<Widget> wg = [];

  final PanelController _pc = PanelController();

  Widget getItemCard(String code) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 3.0,
        right: 10.0,
      ),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(code),
              ],
            ),
          ),
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("クリップボードにコピーしました。")),
            );
          },
          onTap: () {
            var regex =
                RegExp(r"https?://[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+");
            if (regex.hasMatch(code)) {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Row(children: const [
                      Icon(Icons.open_in_browser),
                      Text("ブラウザで開く"),
                    ]),
                    content: Text(code),
                    actions: [
                      TextButton(
                        child: const Text("キャンセル"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("開く"),
                        onPressed: () async {
                          var uri = Uri.parse(code);
                          if (!await canLaunchUrl(uri)) return;
                          launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void update() {
    setState(() {
      _counts = codes.length;
      wg = [];
      for (var element in codes) {
        if (element.rawValue == null) continue;
        wg.add(getItemCard(element.rawValue!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("読み込み"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _buildQrView(context),
              ),
              const SizedBox(
                height: 100.0 - edgeSize,
              ),
            ],
          ),
          LayoutBuilder(
            builder: (key, builder) => SlidingUpPanel(
              controller: _pc,
              maxHeight: builder.maxHeight,
              panel: SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100.0,
                      child: Center(
                        child: Text("$_counts件読み込みました"),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          ...wg,
                        ],
                      ),
                    ),
                    _bottomButtons(),
                  ],
                ),
              ),
              borderRadius: borderRadius,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10.0,
      ),
      child: Row(
        children: [
          Expanded(
            // 削除ボタン
            flex: 1,
            child: FilledTonalButton(
              style: FilledTonalButton.styleFrom(
                primary: Theme.of(context).errorColor,
              ),
              onPressed: () {
                codes = [];
                update();
              },
              child: const Text(
                "全て削除",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            //閉じるボタン
            flex: 2,
            child: FilledTonalButton(
              onPressed: () {
                _pc.close();
              },
              child: const Text("閉じる"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    bool isExistData(Barcode barcode) {
      var readRaw = barcode.rawBytes?.join() ?? "";
      return codes
          .where((Barcode code) => (code.rawBytes?.join() ?? "") == readRaw)
          .isNotEmpty;
    }

    return MobileScanner(
      allowDuplicates: true,
      onDetect: (barcode, args) {
        if (isExistData(barcode)) return;
        if (barcode.rawValue == null) return;
        codes.add(barcode);
        update();
      },
    );
  }
}
