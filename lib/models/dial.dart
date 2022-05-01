import 'package:plan_dial_renewal/models/time.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';

/// Default Dial Class
class Dial {
  String name;
  final int id;
  DateTime startTime;

  int? durationInSeconds;
  bool disabled;
  WeekSchedule schedule;

  Dial(
      {required this.name,
      required this.id,
      required this.startTime,
      this.durationInSeconds,
      this.disabled = false,
      required this.schedule});

  /// 현재로부터 가장 가까운 알람 시기를 리턴하는 함수.
  DateTime? getNearestDateTime() {
    final now = DateTime.now();
    final diff = now.difference(startTime);

    if (diff.isNegative) {
      return startTime;
    } else {
      final weekday = now.weekday;
      final todaySchedule = schedule.getTimeByIndex(weekday);

      if (todaySchedule == null || !todaySchedule.isLaterThan(Time.now())) {
        return schedule
            .getNearestTime(weekday)
            ?.toDateTime(now.year, now.month, now.day);
      } else {
        return todaySchedule.toDateTime(now.year, now.month, now.day);
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
      return now.difference(date).inSeconds;
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
}
