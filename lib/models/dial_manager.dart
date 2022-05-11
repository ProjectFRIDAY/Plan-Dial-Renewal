import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';
import 'package:plan_dial_renewal/utils/databases/db_manager.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DialManager {
  static const dayChangeHour = 4;

  static final DialManager _instance = DialManager._internal();
  static final Map dials = <int, Dial>{};
  static final List<Observer> _observers = List.empty(growable: true);

  factory DialManager() {
    return _instance;
  }

  DialManager._internal() {
    loadDialsFromDb();
  }

  Future<void> loadDialsFromDb() async {
    /* TEST CODE */
    // await DbManager().clear();
    // await addDial("다이얼1", DateTime.now(), WeekSchedule(monday: Schedule(Time(15, 30)), tuesday: Schedule(Time(20, 30))));
    // await addDial("다이얼2", DateTime.now(), WeekSchedule(friday: Schedule(Time(17, 30))));
    // await addDial("다이얼3", DateTime.now(), WeekSchedule(wednesday: Schedule(Time(1, 30))));

    dials.addAll(await DbManager().loadAllDials());
    notifyObservers();
  }

  int getDialCount() {
    return dials.length;
  }

  Dial getDialByIndex(int index) {
    return dials[index];
  }

  void removeDialByIndex(int index) {
    dials.remove(index);
    DbManager().deleteDialByIndex(index);
    notifyObservers();
  }

  List getAllDials() {
    return dials.values.toList();
  }

  Future<void> addDial(String name, DateTime startTime, WeekSchedule schedule) async {
    var dial = Dial(
      name: name,
      startTime: startTime,
      weekSchedule: schedule,
    );

    int id = await DbManager().addDial(dial);
    dial.id = id;
    dials[id] = dial;
    notifyObservers();
  }

  void updateDial(Dial dial) {
    DbManager().updateDial(dial);
    notifyObservers();
  }

  /// 가장 가까운 다이얼 딱 1개 리턴
  Dial? getUrgentDial() {
    if (getDialCount() == 0) return null;

    int seconds = 60 * 60 * 24 * 7;
    Dial? result;

    for (Dial dial in getAllDials()) {
      if (dial.getLeftTimeInSeconds() < seconds && !dial.disabled) {
        result = dial;
        seconds = dial.getLeftTimeInSeconds();
      }
    }

    return result;
  }

  /// 오늘에 해당되는 다이얼 모두 리턴
  List<Dial> getTodayDials() {
    var result = List<Dial>.empty(growable: true);
    var now = DateTime.now();
    var last = DateTime(now.year, now.month, now.day, dayChangeHour);

    if (last.isAfter(now)) {
      last = last.subtract(const Duration(days: 1));
    }

    for (Dial dial in getAllDials()) {
      if (dial.hasScheduleIn(last, now) && !dial.disabled) {
        result.add(dial);
      }
    }

    return result;
  }

  /// 모든 다이얼의 일정 Appointment로 리턴
  List<Appointment> getAllDialsAsAppointments() {
    var result = List<Appointment>.empty(growable: true);

    for (Dial dial in getAllDials()) {
      result.addAll(dial.toAppointments(CupertinoColors.activeBlue));
    }

    return result;
  }

  void addObserver(Observer observer) {
    _observers.add(observer);
  }

  void notifyObservers() {
    for (Observer observer in _observers) {
      observer.onChanged();
    }
  }
}

abstract class Observer {
  void onChanged();
}
