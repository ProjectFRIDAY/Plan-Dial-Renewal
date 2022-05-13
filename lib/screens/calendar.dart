import 'package:flutter/cupertino.dart';
import 'package:plan_dial_renewal/models/dial_manager.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// TimeTable 페이지의 캘린더
class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> implements Observer {
  _CalendarState() {
    DialManager().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    DateTime baseDate = DateTime(now.year, now.month, now.day);
    baseDate = baseDate.subtract(Duration(days: baseDate.weekday - 1));

    return SfCalendar(
      view: CalendarView.week,
      todayHighlightColor: Color.fromARGB(196, 145, 48, 255),
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

  @override
  void onChanged() {
    if (mounted) setState(() {});
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
