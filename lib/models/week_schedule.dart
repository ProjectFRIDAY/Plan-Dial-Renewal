import 'dart:ui';

import 'package:plan_dial_renewal/models/schedule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// 일주일 일정 스케쥴을 담는 클래스
class WeekSchedule {
  final Schedule? monday;
  final Schedule? tuesday;
  final Schedule? wednesday;
  final Schedule? thursday;
  final Schedule? friday;
  final Schedule? saturday;
  final Schedule? sunday;

  WeekSchedule(
      {this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  /// 인덱스로 일정에 접근하는 함수
  Schedule? getScheduleByIndex(int weekdayIndex) {
    switch (weekdayIndex) {
      case DateTime.monday:
        return monday;
      case DateTime.tuesday:
        return tuesday;
      case DateTime.wednesday:
        return wednesday;
      case DateTime.thursday:
        return thursday;
      case DateTime.friday:
        return friday;
      case DateTime.saturday:
        return saturday;
      case DateTime.sunday:
        return sunday;
      default:
        return null;
    }
  }

  /// 가장 가까운 일정이 있는 요일의 일정을 반환하는 함수 (오늘 제외)
  Schedule? getNearestSchedule(int weekdayIndex) {
    int index = weekdayIndex % 7 + 1;

    while (index != weekdayIndex) {
      final schedule = getScheduleByIndex(weekdayIndex);
      if (schedule != null) return schedule;
      index = index % 7 + 1;
    }

    return null;
  }

  /// 스케줄들을 Appointment로 반환하는 함수
  List<Appointment> toAppointments(String title, Color color) {
    var result = List<Appointment>.empty();

    DateTime baseDate = DateTime.now();
    Duration baseDuration = const Duration(days: 1);
    baseDate.subtract(Duration(days: baseDate.weekday));

    for (int i = 1; i <= 7; ++i) {
      baseDate.add(baseDuration);
      var schedule = getScheduleByIndex(i);
      if (schedule != null) {
        result.add(schedule.toAppointment(title, color, baseDate));
      }
    }

    return result;
  }
}
