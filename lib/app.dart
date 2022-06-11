import 'package:codereader/pages/about.dart';
import 'package:codereader/pages/camera.dart';
import 'package:codereader/pages/main_page.dart';
import 'package:codereader/pages/result.dart';
import 'package:codereader/pages/setting.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Reader',
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const MyHomePage(title: 'Code Reader Home'),
      routes: {
        "/camera": (BuildContext context) => const CameraPage(),
        "/result": (BuildContext context) => const ResultPageState(),
        "/about": (BuildContext context) => const AboutPageState(),
        "/setting": (BuildContext context) => const SettingPageState(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}
