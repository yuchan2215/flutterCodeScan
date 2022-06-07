import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:codereader/models/barcode_component.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kotlin_flavor/scope_functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

List<BarcodeComponent> getCalendarComponent(CalendarEvent? event) {
  if (event == null) return [];
  var e = event;
  //日付の変換用
  initializeDateFormatting("ja");
  var formatter = DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");

  //開始と終了を取得
  var formattedStart = e.start?.let((self) {
    return formatter.format(self);
  });
  var formattedEnd = e.end?.let((self) {
    return formatter.format(self);
  });

  return [
    _getOpenCalendarComponent(e),
    BarcodeComponent(
      title: "タイトル",
      content: e.summary,
      isImportant: true,
    ),
    BarcodeComponent(
        title: "説明", content: e.description, showTitleInResult: true),
    BarcodeComponent(
      title: "主催者",
      content: e.organizer,
      showTitleInResult: true,
    ),
    BarcodeComponent(
      title: "ステータス",
      content: e.status,
      showTitleInResult: true,
    ),
    BarcodeComponent(
      title: "場所",
      content: e.location,
      showTitleInResult: true,
    ),
    BarcodeComponent(
      title: "開始日時",
      content: formattedStart,
      showTitleInResult: true,
    ),
    BarcodeComponent(
      title: "終了日時",
      content: formattedEnd,
      showTitleInResult: true,
    ),
  ];
}

BarcodeComponent _getOpenCalendarComponent(CalendarEvent e) {
  return BarcodeComponent(
      title: "",
      content: "タップしてイベントを作成",
      onTap: (context) {
        if (e.start == null) return;
        if (e.end == null) return;
        var event = Event(
          title: e.summary ?? "",
          startDate: e.start!,
          endDate: e.end!,
          description: e.description ?? '',
          location: e.location ?? '',
        );
        Add2Calendar.addEvent2Cal(event);
      });
}
