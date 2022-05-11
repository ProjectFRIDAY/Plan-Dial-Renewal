import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    DateTime baseDate = DateTime(now.year, now.month, now.day);
    baseDate = baseDate.subtract(Duration(days: baseDate.weekday - 1));

    return SfCalendar(
      view: CalendarView.week,
      timeSlotViewSettings:
          const TimeSlotViewSettings(timeInterval: Duration(hours: 2)),
      headerHeight: 0,
      dataSource: MeetingDataSource(DialManager().getAllDialsAsAppointments()),
      firstDayOfWeek: 1,
      maxDate: baseDate
          .add(const Duration(days: 7))
          .subtract(const Duration(seconds: 1)),
      minDate: baseDate,
    );
  }
}

@Deprecated("For Test")
List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 13, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 1));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'test',
      color: CupertinoColors.activeBlue,
      // 나중에 요일별 다이얼로 대체할 예정임.
      recurrenceRule: 'FREQ=DAILY;COUNT=3'));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
