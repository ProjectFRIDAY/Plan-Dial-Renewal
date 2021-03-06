import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/time.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Default Dial Class
class Dial {
  String name;
  int id;
  DateTime startTime;

  bool disabled;
  WeekSchedule weekSchedule;

  Dial(
      {required this.name,
      this.id = -1,
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
      int nearestWeekday = weekSchedule.getNearestSchedule(weekday);

      if (nearestWeekday == 0) return null;

      int cha = nearestWeekday - weekday;
      var schedule = weekSchedule.getScheduleByIndex(nearestWeekday);

      if (schedule != null &&
          cha == 0 &&
          Time(now.hour, now.minute).isLaterThan(schedule.start)) {
        nearestWeekday = weekSchedule.getNearestSchedule(weekday % 7 + 1);
        cha = nearestWeekday - weekday;
        if (cha == 0) cha = 7;
        schedule = weekSchedule.getScheduleByIndex(nearestWeekday);
      }

      if (cha < 0) cha += 7;

      return schedule?.start
          .toDateTime(now.year, now.month, now.day)
          .add(Duration(days: cha));
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
      seconds = (seconds / (60 * 60 * 24)).floor();
      return seconds.toString() + "일 전";
    } else if (seconds >= 60 * 60) {
      seconds = (seconds / (60 * 60)).floor();
      return seconds.toString() + "시간 전";
    } else if (seconds >= 0) {
      seconds = (seconds / 60).floor();
      return seconds.toString() + "분 전";
    } else {
      return "지금";
    }
  }

  /// 해당 기간에 스케줄이 있는지 확인하는 함수
  bool hasScheduleIn(DateTime from, DateTime to) {
    const day = Duration(days: 1);
    var tmp = DateTime(from.year, from.month, from.day);

    while (to.isAfter(tmp)) {
      var schedule = weekSchedule.getScheduleByIndex(tmp.weekday);

      if (schedule != null) {
        if (to.year == tmp.year &&
            to.month == tmp.month &&
            to.day == from.day) {
          return Time(to.hour, to.minute).isLaterThan(schedule.finish);
        } else {
          return true;
        }
      }

      tmp = tmp.add(day);
    }

    return false;
  }

  /// 스케줄들을 Appointment로 반환하는 함수
  List<Appointment> toAppointments(Color color) {
    return weekSchedule.toAppointments(name, color);
  }

  @Deprecated("해당 방식의 UI를 사용하지 않음.")
  CupertinoListTile toListTile(Icon icon) {
    return CupertinoListTile(
      leading: icon,
      title: Text(name),
      subtitle: Text(secondsToString(getLeftTimeInSeconds())),
      border: const Border(),
    );
  }

  /// 알림의 최초 실행 날짜 및 시간 구하기
  DateTime getFirstDateTime() {
    const day = Duration(days: 1);
    var now = DateTime.now();
    var tmp = DateTime(startTime.year, startTime.month, startTime.day);

    for (int i = 0; i < 8; i++) {
      var schedule = weekSchedule.getScheduleByIndex(tmp.weekday);

      if (schedule != null) {
        var result = schedule.start.toDateTime(tmp.year, tmp.month, tmp.day);

        if (i > 0 || result.isAfter(now)) {
          return result;
        }
      }

      tmp = tmp.add(day);
    }

    assert(false, "최초 실행 시간을 구할 수 없습니다.");
    return startTime;
  }

  @override
  String toString() {
    return name;
  }
}