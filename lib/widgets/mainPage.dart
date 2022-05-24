import 'package:flutter/material.dart';

import '../app.dart';

class MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          "Hello World",
        ),
      ),
    );
  }
}
