import 'package:plan_dial_renewal/models/dial.dart';

class DialManager {
  static final DialManager _instance = DialManager._internal();
  static final Map dials = <int, Dial>{};

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

  void removeAllDials() {
    dials.clear();
  }

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
}
