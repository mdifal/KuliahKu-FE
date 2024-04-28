import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/calender/meeting.dart';
import 'package:kuliahku/ui/widgets/calender/meeting_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderSchedule extends StatefulWidget {
  const CalenderSchedule({Key? key}) : super(key: key);

  @override
  State<CalenderSchedule> createState() => _CalenderScheduleState();
}

class _CalenderScheduleState extends State<CalenderSchedule> {
  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday -1 ));
    DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 5));

    // if (today.weekday == DateTime.sunday) {
    //   firstDayOfWeek = today.subtract(Duration(days: 6));
    //   lastDayOfWeek = today;
    // }

    final DateTime startOfFirstDay =
        DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
    final DateTime endOfLastDay = DateTime(
        lastDayOfWeek.year, lastDayOfWeek.month, lastDayOfWeek.day, 23, 59, 59);

    List<Meeting> _getDataSource() {
      List<Meeting> meetings = <Meeting>[];
      // final DateTime today = DateTime.now();
      // final DateTime startTime =
      //     DateTime(today.year, today.month, today.day, 9, 0, 0);
      // final DateTime endTime = startTime.add(const Duration(hours: 2));
      meetings.add(Meeting('Basis Data', DateTime(2024, 4, 22, 9, 0, 0),
          DateTime(2024, 4, 22, 11, 0, 0), yellow, false));
      meetings.add(Meeting('Proyek 3', DateTime(2024, 4, 22, 13, 0, 0),
          DateTime(2024, 4, 22, 14, 0, 0), darkBlue, false));

      return meetings;
    }

    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 6,
          endHour: 21,
        ),
        minDate: startOfFirstDay, // Set tanggal awal minggu ini (Senin)
        maxDate: endOfLastDay, // Set tanggal akhir minggu ini (Sabtu)
        dataSource: MeetingDataSource(_getDataSource()),
      ),
    );
  }
}
