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
            items: <String>['Menu 1', 'Menu 2', 'Menu 3']
                .map((String value) {
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
                startHour: 9,
                endHour: 16,
                nonWorkingDays: <int>[DateTime.sunday, DateTime.saturday]),
          ),
        ),
      ),
    );
  }
}