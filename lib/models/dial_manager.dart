import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';
import 'package:plan_dial_renewal/utils/db_manager.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../utils/colors.dart';
import '../utils/noti_manager.dart';
import 'schedule.dart';
import 'time.dart';

class DialManager {
  static const dayChangeHour = 4;

  static final DialManager _instance = DialManager._internal();
  static final Map dials = <int, Dial>{};
  static final List<Observer> _observers = List.empty(growable: true);
  static final List<Color> _colors = List.empty(growable: true);

  factory DialManager() {
    return _instance;
  }

  DialManager._internal() {
    _colors.addAll(getRainbowColors(230, 170));
    _colors.addAll(getRainbowColors(200, 100));
    _colors.addAll(getRainbowColors(120, 50));
    loadDialsFromDb();
  }

  Future<void> loadDialsFromDb() async {
    /* TEST CODE */
    // await DbManager().clear();
    // await NotiManager().removeAllNotifications();
    // await addDial(
    //     "다이얼1",
    //     DateTime.now(),
    //     WeekSchedule(
    //         monday: Schedule(Time(15, 30)), tuesday: Schedule(Time(20, 30))));
    // await addDial(
    //     "다이얼2", DateTime.now(), WeekSchedule(friday: Schedule(Time(17, 30))));
    // await addDial("다이얼3", DateTime.now(), WeekSchedule(wednesday: Schedule(Time(1, 30))), disabled: true);
    // await addDial("다이얼4", DateTime.now(), WeekSchedule(wednesday: Schedule(Time(21, 5)), sunday: Schedule(Time(9, 30), Time(21, 30))));

    dials.addAll(await DbManager().loadAllDials());
    notifyObservers();
  }

  int getDialCount() {
    return dials.length;
  }

  Dial getDialById(int id) {
    return dials[id];
  }

  Future<void> removeDialById(int id) async {
    dials.remove(id);
    await DbManager().deleteDialByIndex(id);
    NotiManager().removeNotification(id);
    notifyObservers();
  }

  Future<void> removeAllDials() async {
    dials.clear();
    await DbManager().clear();
    NotiManager().removeAllNotifications();
    notifyObservers();
  }

  List getAllDials() {
    return dials.values.toList();
  }

  Future<void> addDial(String name, DateTime startTime, WeekSchedule schedule,
      {bool disabled = false}) async {
    assert(!schedule.isEmpty(), "일정이 없는 다이얼은 생성할 수 없습니다.");

    var dial = Dial(
      name: name,
      startTime: startTime,
      weekSchedule: schedule,
      disabled: disabled,
    );

    int id = await DbManager().addDial(dial);
    dial.id = id;
    dials[id] = dial;

    if (!disabled) {
      NotiManager().addNotification(id, name, dial.getFirstDateTime());
    }

    notifyObservers();
  }

  void updateDial(Dial dial) {
    DbManager().updateDial(dial);
    if (dial.disabled) {
      NotiManager().removeNotification(dial.id);
    } else {
      NotiManager()
          .updateNotification(dial.id, dial.name, dial.getFirstDateTime());
    }
    notifyObservers();
  }

  /// 가장 가까운 다이얼 딱 1개 리턴
  Dial? getUrgentDial({bool containDisabled = true}) {
    if (getDialCount() == 0) return null;

    int seconds = 60 * 60 * 24 * 7;
    Dial? result;

    for (Dial dial in getAllDials()) {
      if (dial.getLeftTimeInSeconds() < seconds &&
          (containDisabled || !dial.disabled)) {
        result = dial;
        seconds = dial.getLeftTimeInSeconds();
      }
    }

    return result;
  }

  /// 오늘에 해당되는 다이얼 모두 리턴
  List<Dial> getTodayDials({bool containDisabled = true}) {
    var result = List<Dial>.empty(growable: true);
    var now = DateTime.now();
    var last = DateTime(now.year, now.month, now.day, dayChangeHour);

    if (last.isAfter(now)) {
      last = last.subtract(const Duration(days: 1));
    }

    for (Dial dial in getAllDials()) {
      if (dial.hasScheduleIn(last, now) &&
          (containDisabled || !dial.disabled)) {
        result.add(dial);
      }
    }

    return result;
  }

  /// 모든 다이얼의 일정 Appointment로 리턴
  List<Appointment> getAllDialsAsAppointments() {
    var result = List<Appointment>.empty(growable: true);
    int colorPicker = 0;

    for (Dial dial in getAllDials()) {
      if (dial.disabled) {
        result.addAll(dial.toAppointments(CupertinoColors.inactiveGray));
      } else {
        result.addAll(dial.toAppointments(_colors[colorPicker]));
        colorPicker = (colorPicker + 1) % _colors.length;
      }
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
