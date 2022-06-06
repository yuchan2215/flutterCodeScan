import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:codereader/models/barcode_component.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

BarcodeComponent getCalendarComponent(CalendarEvent? e) {
  return BarcodeComponent(
      title: "",
      content: "タップしてメールを作成",
      onTap: (context) {
        if (e == null) return;
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
