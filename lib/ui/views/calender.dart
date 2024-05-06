import 'package:flutter/material.dart';
import 'package:kuliahku/ui/widgets/calender_schedule.dart';
import 'package:kuliahku/ui/widgets/calender_task.dart';

class CalenderTaskandSchedulePage extends StatefulWidget {
  const CalenderTaskandSchedulePage({super.key});

  @override
  State<CalenderTaskandSchedulePage> createState() =>
      _CalenderTaskandSchedulePageState();
}

class _CalenderTaskandSchedulePageState
    extends State<CalenderTaskandSchedulePage> {
  Widget calender = CalenderTask();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jadwal '),
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: 'schedule', child: Text('Jadwal')),
                  const PopupMenuItem<String>(
                    value: 'task',
                    child: Text('Tugas'),
                  ),
                ],
                onSelected: (String value) {
                  setState(() {
                    switch (value) {
                      case 'task':
                        calender = CalenderTask();
                        break;
                      case 'schedule':
                        calender = CalenderSchedule();
                        break;
                    }
                  });
                },
                icon: Icon(Icons.more_vert), // Ikon titik tiga
              ),
            ],
          ),
        ),
        body: calender,
      ),
    );
  }
}
