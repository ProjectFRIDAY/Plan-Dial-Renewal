import 'dart:ui';

import 'package:plan_dial_renewal/models/time.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// 시작일, 종료일을 담는 클래스
class Schedule {
  static const defaultDuration = 1;
  final Time start;
  late final Time finish;

  Schedule(this.start, [Time? finish]) {
    if (finish == null) {
      this.finish = Time((start.hour + defaultDuration) % 24, start.minute);
    } else {
      this.finish = finish;
    }
  }

  Appointment toAppointment(String title, Color color, DateTime date) {
    var startTime = start
        .toDateTime(date.year, date.month, date.day)
        .subtract(const Duration(days: 7));

    var endTime = finish
        .toDateTime(date.year, date.month, date.day)
        .subtract(const Duration(days: 7));

    if (startTime.isAfter(endTime)) {
      endTime = endTime.add(const Duration(days: 1));
    } else if (startTime.add(const Duration(hours: 1)).isAfter(endTime)) {
      endTime = startTime.add(const Duration(hours: 1));
    }

    return Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: title,
      color: color,
      recurrenceRule: "FREQ=DAILY;INTERVAL=7;COUNT=2",
    );
  }

  @override
  String toString() {
    return start.toString() + "~" + finish.toString();
  }

  static Schedule? parse(String string) {
    if (string.isEmpty) return null;
    var split = string.split("~");
    return Schedule(Time.parse(split[0]), Time.parse(split[1]));
  }
}
