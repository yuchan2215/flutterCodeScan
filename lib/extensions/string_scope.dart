extension StringScopeExt on String? {
  String? get emptyConvert {
    if (this == null) return null;
    var str = this as String;
    if (str.isEmpty) {
      return null;
    } else {
      return str;
    }
  }
}
