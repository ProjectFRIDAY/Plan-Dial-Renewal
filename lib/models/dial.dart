import 'dart:ui';

import 'package:plan_dial_renewal/models/time.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Default Dial Class
class Dial {
  String name;
  final int id;
  DateTime startTime;

  bool disabled;
  WeekSchedule weekSchedule;

  Dial(
      {required this.name,
      required this.id,
      required this.startTime,
      this.disabled = false,
      required this.weekSchedule});

  /// 현재로부터 가장 가까운 알람 시기를 리턴하는 함수.
  DateTime? getNearestDateTime() {
    final now = DateTime.now();
    final diff = now.difference(startTime);

    if (diff.isNegative) {
      return startTime;
    } else {
      final weekday = now.weekday;
      final todaySchedule = weekSchedule.getScheduleByIndex(weekday);

      if (todaySchedule == null ||
          !todaySchedule.start.isLaterThan(Time.now())) {
        return weekSchedule
            .getNearestSchedule(weekday)
            ?.start
            .toDateTime(now.year, now.month, now.day);
      } else {
        return todaySchedule.start.toDateTime(now.year, now.month, now.day);
      }
    }
  }

  /// 가장 가까운 알람 시기까지 남은 시간을 리턴하는 함수.
  int getLeftTimeInSeconds() {
    final date = getNearestDateTime();
    final now = DateTime.now();

    if (date == null) {
      return -1;
    } else {
      return date.difference(now).inSeconds;
    }
  }

  static String secondsToString(int seconds) {
    if (seconds >= 60 * 60 * 24) {
      seconds %= (60 * 60 * 24);
      return seconds.toString() + "일 전";
    } else if (seconds >= 60 * 60) {
      seconds %= (60 * 60);
      return seconds.toString() + "시간 전";
    } else {
      seconds %= 60;
      return seconds.toString() + "분 전";
    }
  }

  /// 해당 요일에 스케줄이 있는지 확인하는 함수
  bool hasSchedule(int weekday) {
    return weekSchedule.getScheduleByIndex(weekday) != null;
  }

  /// 스케줄들을 Appointment로 반환하는 함수
  List<Appointment> toAppointments(Color color) {
    return weekSchedule.toAppointments(name, color);
  }
}
