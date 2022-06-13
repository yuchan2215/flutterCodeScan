import 'package:codereader/pages/result.dart';

///[ResultPageState]で表示される追加情報のためのクラス。
class AdditionalInformation {
  AdditionalInformation({
    required this.title,
    required this.value,
    this.isExpanded = false,
  });

  String title;
  String? value;
  bool isExpanded;
}
