import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      timeSlotViewSettings:
          const TimeSlotViewSettings(timeInterval: Duration(hours: 2)),
      headerHeight: 0,
    );
  }
}
