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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Kalender'),
        ),
        body: CalenderSchedule(),
      ),
    );
  }
}
