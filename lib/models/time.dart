/// 시, 분만 저장하는 Time 클래스
class Time {
  final int hour;
  final int minute;

  Time(this.hour, this.minute);

  DateTime toDateTime([int year = 2022, int month = 1, int day = 1]) {
    return DateTime(year, month, day, hour, minute);
  }

  bool isLaterThan(Time targetTime) {
    if (hour == targetTime.hour) {
      return minute > targetTime.minute;
    } else {
      return hour > targetTime.hour;
    }
  }

  @override
  String toString() {
    return hour.toString() + ":" + minute.toString();
  }

  static Time parse(String string) {
    var split = string.split(":");
    return Time(int.parse(split[0]), int.parse(split[1]));
  }

  static Time now() {
    final now = DateTime.now();
    return Time(now.hour, now.minute);
  }
}
