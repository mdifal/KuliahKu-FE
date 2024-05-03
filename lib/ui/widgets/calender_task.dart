import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/detail_plan.dart';
import 'package:kuliahku/ui/widgets/calender/task.dart';
import 'package:kuliahku/ui/widgets/calender/task_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CalenderTask extends StatefulWidget {
  const CalenderTask({super.key});

  @override
  State<CalenderTask> createState() => _CalenderTaskState();
}

class _CalenderTaskState extends State<CalenderTask> {
  List<Meeting> meetings = <Meeting>[];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  List<Meeting> _getDataSource() {
    
    return meetings;
  }

  Future<void> _fetchData() async {
  var url = 'http://$ipUrl:8001/users/$email/rencanaMandiri';

  try {
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> dataTugas = jsonResponse['data'];
      List<Meeting> fetchedMeetings = <Meeting>[];

      for (var data in dataTugas) {
       String id = data['id'] ?? '';
        String eventName = data['title'] ?? '';
        DateTime dateTimeReminder = DateTime.parse(data['dateTimeReminder']);
        DateTime dateTimeDeadline = DateTime.parse(data['dateTimeDeadline']);
        Color color = Color(data['color']);

        fetchedMeetings.add(Meeting(id, eventName, dateTimeReminder, dateTimeDeadline, color));
      }

      setState(() {
        meetings = fetchedMeetings;
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  void _handleAgendaTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      final Meeting meeting = details.appointments![0] as Meeting;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPlanPage(idTask: meeting.idEvent),
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
      onTap: _handleAgendaTap,
      appointmentBuilder: _appointmentBuilder,
    ));
  }

  Widget _appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final Meeting meeting = details.appointments.first as Meeting;
    return Container(
      decoration: BoxDecoration(
        color: meeting.appointmentColor,
        borderRadius: BorderRadius.circular(4), // Menambahkan border radius 4
      ),
      padding: EdgeInsets.all(5), // Menambahkan padding untuk penyesuaian
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
        children: [
          Text(
            meeting.eventName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                'Deadline : ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(width: 8),
              Text(
                DateFormat('dd MMMM yyyy').format(meeting.deadline),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
