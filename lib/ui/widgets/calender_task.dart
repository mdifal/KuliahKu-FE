import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/detail_plan.dart';
import 'package:kuliahku/ui/widgets/calender/meeting.dart';
import 'package:kuliahku/ui/widgets/calender/meeting_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderTask extends StatefulWidget {
  const CalenderTask({super.key});

  @override
  State<CalenderTask> createState() => _CalenderTaskState();
}

class _CalenderTaskState extends State<CalenderTask> {
  List<Meeting> _getDataSource() {
    List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    Color color = Color(0xFF89D592); 
    meetings.add(Meeting('Conference', startTime, endTime, color, 'a', 'a', false));
    meetings.add(Meeting('Conference3', startTime, endTime, color, 'a', 'a', false));

    return meetings;
  }

  void _handleAgendaTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      final Meeting meeting = details.appointments![0] as Meeting;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPlanPage(agenda : meeting.eventName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.month,
      todayHighlightColor: darkBlue,
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      dataSource: MeetingDataSource(_getDataSource()),
      selectionDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: yellow, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle),
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          showAgenda: true),
          onTap: _handleAgendaTap
    )
    );
  }
}
