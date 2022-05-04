import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DialManager {
  static final DialManager _instance = DialManager._internal();
  static final Map dials = <int, Dial>{};
  static int id = 1;

  factory DialManager() {
    return _instance;
  }

  DialManager._internal() {
    // TODO 최초 1회 생성자 내용 넣기
  }

  int getDialCount() {
    return dials.length;
  }

  Dial getDialByIndex(int index) {
    return dials[index];
  }

  void removeDialByIndex(int index) {
    dials.remove(index);
  }

  List getAllDials() {
    return dials.values.toList();
  }

  void addDial(String name, DateTime startTime, WeekSchedule schedule) {
    dials[id] = Dial(
      name: name,
      id: id++,
      startTime: startTime,
      weekSchedule: schedule,
    );
  }

  void removeAllDials() {
    dials.clear();
  }

  /// 가장 가까운 다이얼 딱 1개 리턴
  Dial? getUrgentDial() {
    if (getDialCount() == 0) return null;

    int seconds = 60 * 60 * 24 * 7;
    Dial? result;

    for (Dial dial in getAllDials()) {
      if (dial.getLeftTimeInSeconds() < seconds) {
        result = dial;
        seconds = dial.getLeftTimeInSeconds();
      }
    }

    return result;
  }

  /// 오늘에 해당되는 다이얼 모두 리턴
  List<Dial> getTodayDials() {
    var result = List<Dial>.empty();

    for (Dial dial in getAllDials()) {
      if (dial.hasSchedule(DateTime.now().weekday)) {
        result.add(dial);
      }
    }

    return result;
  }

  /// 모든 다이얼의 일정 Appointment로 리턴
  List<Appointment> getAllDialsAsAppointments() {
    var result = List<Appointment>.empty();

    for (Dial dial in getAllDials()) {
      result.addAll(dial.toAppointments(CupertinoColors.activeBlue));
    }

    return result;
  }
}
