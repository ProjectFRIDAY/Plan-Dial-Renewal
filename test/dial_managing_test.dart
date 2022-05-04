import 'package:flutter_test/flutter_test.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';
import 'package:plan_dial_renewal/models/schedule.dart';
import 'package:plan_dial_renewal/models/time.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';

void main() {
  test("다이얼 매니저 초기 생성 테스트", () {
    var dialManager = DialManager();
    expect(dialManager.getDialCount(), equals(0));
    expect(dialManager.getAllDials(), isEmpty);
    expect(dialManager.getUrgentDial(), isNull);
    expect(dialManager.getTodayDials(), isEmpty);
    expect(dialManager.getAllDialsAsAppointments(), isEmpty);
  });

  test("다이얼 생성 테스트", () {
    var dial = Dial(
      name: "다이얼1",
      id: 1,
      startTime: DateTime.now(),
      weekSchedule: WeekSchedule(
        monday: Schedule(
          Time(10, 30),
        ),
      ),
    );

    expect(dial.getNearestDateTime(), isNotNull);
    expect(dial.getLeftTimeInSeconds(), isPositive);
  });
}
