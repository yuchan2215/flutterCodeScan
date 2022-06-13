import 'package:awesome_select/awesome_select.dart';
import 'package:codereader/main.dart';
import 'package:codereader/widgets/settings/stop_timing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsWidget extends StatefulWidget {
  final SharedPreferences preferences;

  const SettingsWidget({
    required this.preferences,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late bool autoOpen = widget.preferences.getBool(autoOpenKey) ?? true;

  late String stopTiming = widget.preferences.getString(stopTimingKey) ??
      StopTimingExt.getDefault().key;

  final List<S2Choice<String>> options = StopTiming.values
      .map<S2Choice<String>>((e) =>
          S2Choice(value: e.key, title: e.displayTitle, subtitle: e.subTitle))
      .toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text("自動的に開く"),
            subtitle: const Text("コードを検出した際に、自動的に結果一覧のパネルを開きます。"),
            trailing: Switch(
                value: autoOpen,
                onChanged: (value) async {
                  await widget.preferences.setBool(autoOpenKey, value);
                  setState(() {
                    autoOpen = value;
                  });
                }),
          ),
          SmartSelect<String>.single(
            selectedValue: stopTiming,
            title: 'スキャンを停止するタイミング',
            choiceItems: options,
            onChange: (value) {
              if (value.value == null) return;
              widget.preferences.setString(stopTimingKey, value.value!);
            },
            modalType: S2ModalType.bottomSheet,
            tileBuilder: (context, state) {
              //2行にする
              return S2Tile.fromState(
                state,
                isTwoLine: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
