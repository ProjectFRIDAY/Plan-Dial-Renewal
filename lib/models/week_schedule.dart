import 'package:plan_dial_renewal/models/time.dart';

/// 일주일 일정 스케쥴을 담는 클래스
class WeekSchedule {
  final Time? monday;
  final Time? tuesday;
  final Time? wednesday;
  final Time? thursday;
  final Time? friday;
  final Time? saturday;
  final Time? sunday;

  WeekSchedule(
      {this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  /// 인덱스로 일정에 접근하는 함수
  Time? getTimeByIndex(int weekdayIndex) {
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
  Time? getNearestTime(int weekdayIndex) {
    int index = weekdayIndex % 7 + 1;

    while (index != weekdayIndex) {
      final schedule = getTimeByIndex(weekdayIndex);
      if (schedule != null) return schedule;
      index = index % 7 + 1;
    }

    return null;
  }
}
