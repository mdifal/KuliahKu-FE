import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class kalenderJadwal extends StatefulWidget {
  const kalenderJadwal({super.key});

  @override
  State<kalenderJadwal> createState() => _kalenderJadwalState();
}

class _kalenderJadwalState extends State<kalenderJadwal> {
  String? _selectedMenuItem;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                color: white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedMenuItem, // Nilai yang dipilih
                items:
                    <String>['Menu 1', 'Menu 2', 'Menu 3'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMenuItem = newValue; // Perbarui nilai yang dipilih
                  });
                },
              ),
            ],
          ),
          backgroundColor: mainColor,
        ),
        body: Center(
          child: SfCalendar(
            view: CalendarView.workWeek,
            timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 6,
                endHour: 21,
                nonWorkingDays: <int>[DateTime.sunday]),
            dataSource: MeetingDataSource(getAppointments()),
          ),
        ),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime =
      DateTime(today.year, today.month, today.day, 11, 0, 0);

  meetings.add(Appointment(
      startTime: DateTime(today.year, today.month, today.day, 9, 0, 0),
      endTime: DateTime(today.year, today.month, today.day, 11, 0, 0),
      subject: "Basis Data",
      color: Color(0xFF89D592),
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO'));

  meetings.add(Appointment(
      startTime: DateTime(today.year, today.month, today.day, 13, 0, 0),
      endTime: DateTime(today.year, today.month, today.day, 14, 0, 0),
      subject: "Proyek 3",
      color: Color(0xFFFFCC00),
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO'));
  meetings.add(Appointment(
      startTime: DateTime(today.year, today.month, today.day, 13, 0, 0),
      endTime: DateTime(today.year, today.month, today.day, 14, 0, 0),
      subject: "PPL",
      color: Color(0xFFFFCC00),
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU'));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
