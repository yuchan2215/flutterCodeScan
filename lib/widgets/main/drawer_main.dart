import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: DrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Text(
                    "コードスキャナー",
                    style: Theme.of(context).primaryTextTheme.bodyText1,
                  ),
                ),
              ),
              ListTile(
                title: const Text("設定"),
                leading: const Icon(Icons.settings),
                onTap: () {},
              ),
              Expanded(child: Container()),
              ListTile(
                title: const Text("このアプリについて"),
                leading: const Icon(Icons.info_outline),
                onTap: () {
                  Navigator.of(context).pushNamed("/about");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
