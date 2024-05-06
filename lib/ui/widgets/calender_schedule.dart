import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/views/edit_schedule.dart';
import 'package:kuliahku/ui/widgets/calender/schedule.dart';
import 'package:kuliahku/ui/widgets/calender/schedule_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class CalenderSchedule extends StatefulWidget {
  const CalenderSchedule({Key? key}) : super(key: key);

  @override
  State<CalenderSchedule> createState() => _CalenderScheduleState();
}

class _CalenderScheduleState extends State<CalenderSchedule> {
  List<Meeting> meetings = <Meeting>[];
  DateTime today = DateTime.now();
  late DateTime firstDayOfWeek;
  late DateTime lastDayOfWeek;
  late DateTime startOfFirstDay;
  late DateTime endOfLastDay;
  Color color = Color(4292030255);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    lastDayOfWeek = firstDayOfWeek.add(Duration(days: 5));
    print('first : $firstDayOfWeek, last : $lastDayOfWeek');
    startOfFirstDay =
        DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
    endOfLastDay = DateTime(
        lastDayOfWeek.year, lastDayOfWeek.month, lastDayOfWeek.day, 23, 59, 59);
    _fetchData();
  }

  List<Meeting> _getDataSource() {
    return meetings;
  }

  Future<void> _fetchData() async {
    var url =
        'http://$ipUrl:8001/users/$email/jadwalKuliah/now?firstDayWeek=$firstDayOfWeek&lastDayWeek=$lastDayOfWeek';

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
          String subject = data['subject'] ?? '';
          String dosen = data['dosen'] ?? '';
          String ruangan = data['ruang'] ?? '';
          DateTime startTime = DateTime.parse(data['startTime']);
          DateTime endTime = DateTime.parse(data['endTime']);
          Color color = Color(data['color']);
          String day = data['day'];

          fetchedMeetings.add(Meeting(id, subject, startTime, endTime, color,
              dosen, ruangan, false, day));
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

  void updateSchedule(String id) {
   Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateSchedulePage(
        id: id,
      ),
    ),
  );
  }

  Future<void> deleteSchedule(String id) async {
    var url = 'http://$ipUrl:8001/users/$email/jadwalKuliah/delete/$id';

    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String message = jsonResponse['message'];
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hapus Jadwal Berhasil'),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hapus Jadwal Gagal'),
                content:
                    Text('Request failed with status: ${response.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Jadwal '),
                      PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                              value: 'update', child: Text('Update')),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (String value) {
                          switch (value) {
                            case 'update':
                              Navigator.of(context).pop();
                              updateSchedule(meeting.id);
                              break;
                            case 'delete':
                              Navigator.of(context).pop();
                              deleteSchedule(meeting.id);
                              didChangeDependencies();
                              break;
                          }
                        },
                        icon: Icon(Icons.more_vert), // Ikon titik tiga
                      ),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Mata Kuliah: ${meeting.eventName}'),
                      Text('Waktu Mulai: ${meeting.from}'),
                      Text('Waktu Selesai: ${meeting.to}'),
                      Text('Hari: ${meeting.day}'),
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
