import 'package:flutter/material.dart';

import '../app.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}): super(key:key);
  @override
  _CameraPageState createState() => _CameraPageState();
}
class _CameraPageState extends State<CameraPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("読み込み"),
      ),
    );
  }
}
