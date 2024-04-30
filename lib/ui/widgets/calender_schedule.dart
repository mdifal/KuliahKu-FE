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
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 5));

    final DateTime startOfFirstDay =
        DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
    final DateTime endOfLastDay = DateTime(
        lastDayOfWeek.year, lastDayOfWeek.month, lastDayOfWeek.day, 23, 59, 59);
    Color color = Color(0xFF89D592); 
    List<Meeting> _getDataSource() {
      List<Meeting> meetings = <Meeting>[];
      meetings.add(Meeting('Basis Data', DateTime(2024, 4, 30, 9, 0, 0),
          DateTime(2024, 4, 30, 11, 0, 0), color , 'a', 'a', false));
      meetings.add(Meeting('Proyek 3', DateTime(2024, 4, 30, 13, 0, 0),
          DateTime(2024, 4, 30, 14, 0, 0), color  , 'a', 'a', false));

      return meetings;
    }

    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            final Meeting meeting = details.appointments![0] as Meeting;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Detail Pertemuan'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Mata Kuliah: ${meeting.eventName}'),
                      Text('Waktu Mulai: ${meeting.from}'),
                      Text('Waktu Selesai: ${meeting.to}'),
                      Text('Dosen: ${meeting.dosen}'),
                      Text('Ruangan: ${meeting.ruangan}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Tutup'),
                    ),
                  ],
                );
              },
            );
          }
        },
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 6,
          endHour: 21,
        ),
        minDate: startOfFirstDay,
        maxDate: endOfLastDay,
        dataSource: MeetingDataSource(_getDataSource()),
      ),
    );
  }
}
