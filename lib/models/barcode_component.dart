enum BarcodeComponentType {
  tel,
  email,
  url,
  other,
}

class BarcodeComponent {
  final String title;
  final String? content;
  final bool isImportant;
  final bool isMemo;
  final bool showTitleInResult;
  final BarcodeComponentType type;
  BarcodeComponent({
    required this.title,
    required this.content,
    this.isImportant = false,
    this.isMemo = false,
    this.showTitleInResult = false,
    this.type = BarcodeComponentType.other,
  });
}
