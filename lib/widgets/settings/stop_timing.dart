enum StopTiming {
  listView,
  resultView,
  none,
}

extension StopTimingExt on StopTiming {
  static StopTiming fromString(String str) {
    var find = StopTiming.values.singleWhere(
      (element) {
        return element.key == str;
      },
      orElse: () => getDefault(),
    );
    return find;
  }

  String get key {
    switch (this) {
      case StopTiming.listView:
        return "list";
      case StopTiming.resultView:
        return "result";
      case StopTiming.none:
        return "none";
    }
  }

  String get displayTitle {
    switch (this) {
      case StopTiming.listView:
        return "結果一覧を開いた時";
      case StopTiming.resultView:
        return "詳細を開いた時";
      case StopTiming.none:
        return "スキャンを停止しない";
    }
  }

  String? get subTitle {
    switch (this) {
      case StopTiming.listView:
        return "読み取り結果一覧画面を表示したタイミングでスキャンを停止します。";
      case StopTiming.resultView:
        return "読み取り結果一覧画面にある要素を選択して、詳細を表示したタイミングでスキャンを停止します。";
      case StopTiming.none:
        return "アプリを終了するか、アプリ内のトップ画面に戻るまでスキャンを継続します。\nただし、ブラウザを開くなど他のアプリに遷移した場合は停止します。";
    }
  }

  bool get scanOnPanel {
    switch (this) {
      case StopTiming.none:
      case StopTiming.resultView:
        return true;
      case StopTiming.listView:
        return false;
    }
  }

  static StopTiming getDefault() {
    return StopTiming.listView;
  }
}
