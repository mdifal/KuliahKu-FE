import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/collab_plan/calender_schedule.dart';
import 'package:kuliahku/ui/views/collab_plan/calender_task.dart';
import 'package:kuliahku/ui/views/make_new_plan.dart';
import 'package:kuliahku/ui/views/make_new_schedule.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CalenderCollabPlanPage extends StatefulWidget {
  final String? calender;
  final String? groupId;
  const CalenderCollabPlanPage({Key? key, this.calender, this.groupId})
      : super(key: key);

  @override
  State<CalenderCollabPlanPage> createState() =>
      _CalenderTaskandSchedulePageState();
}

class _CalenderTaskandSchedulePageState
    extends State<CalenderCollabPlanPage> {
  DateFormat dateFormat = DateFormat('d MMMM yyyy');
  String titleSemester = '';
  String timeSemester = '';
  String SemesterId = '';
  late Widget calender;
  late String _calender = 'task';
  late bool isLoading = true;
  late Semester activeSemester;
  List<Semester> semesters = <Semester>[];

  @override
  void initState() {
    super.initState();
    
  }

  Future<void> _loadCalender() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _calender = prefs.getString('calender') ?? 'task';
      _updateCalenderWidget();
      isLoading = false;
    });
  }

  Future<void> _loadSemester() async {
    activeSemester = _getActiveSemester(semesters);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      titleSemester = prefs.getString('titleSemester') ?? activeSemester.title;
      timeSemester =
          prefs.getString('timeSemester') ?? activeSemester.time;
      SemesterId = prefs.getString('SemesterId') ?? activeSemester.id;
      idSemester = SemesterId; 
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _fetchData();
    _loadCalender();
    _loadSemester();
  }

  Future<void> _saveCalender(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calender', value);
  }

  Future<void> _saveSemester() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('titleSemester', titleSemester);
    await prefs.setString('timeSemester', timeSemester);
    await prefs.setString('SemesterId', SemesterId);
  }

  void _updateCalenderWidget() {
    if (_calender == 'schedule') {
      calender = CalenderScheduleCollabPlan(groupId: widget.groupId);
    } else {
      calender = CalenderTaskCollabPlan(groupId: widget.groupId);
    }
  }

  void ubahsemester(String id) async {
    setState(() {
      idSemester = id;
      final selectedItem = semesters.firstWhere((item) => item.id == id);
      SemesterId = selectedItem.id;
      titleSemester = selectedItem.title;
      timeSemester = selectedItem.time;
      isLoading = true;
    });
    await _saveSemester();
    await _fetchData();
    setState(() {
      isLoading = false;
    });
  }

  Semester _getActiveSemester(List<Semester> semesters) {
    final now = DateTime.now();

    for (final semester in semesters) {
      final startDate = dateFormat.parse(semester.time.split(' - ')[0]);
      final endDate = dateFormat.parse(semester.time.split(' - ')[1]);

      if (now.isAfter(startDate) && now.isBefore(endDate)) {
        return semester;
      }
    }
    return semesters[0];
  }

  List<Semester> _getSemester() {
    return semesters;
  }

  Future<void> _fetchData() async {
    var url = 'http://$ipUrl/users/$email/semesters';

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
        List<dynamic> dataSemester = jsonResponse['semesters'];
        List<Semester> fetchedSemesters = <Semester>[];

        print('ini semester $dataSemester');
        for (var data in dataSemester) {
          String id = data['id'] ?? '';
          String semesterName = 'Semester ${data['semesterNumber']}';
          DateTime endDate = DateTime.parse(data['endDate']);
          DateTime startDate = DateTime.parse(data['startDate']);
          String formattedEndDate = dateFormat.format(endDate);
          String formattedStartDate = dateFormat.format(startDate);
          String timeSemester = '$formattedStartDate - $formattedEndDate';

          fetchedSemesters.add(Semester(id, semesterName, timeSemester));
        }
        setState(() {
          semesters = fetchedSemesters;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleSemester,
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          timeSemester,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    PopupMenuButton<Semester>(
                      itemBuilder: (BuildContext context) =>
                          _getSemester().map((Semester item) {
                        return PopupMenuItem<Semester>(
                          value: item,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title),
                              Text(item.time,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        );
                      }).toList(),
                      onSelected: (Semester value) {
                        setState(() {
                          ubahsemester(value.id);
                        });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 25,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 25,
                      height: 25,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          calender is CalenderTaskCollabPlan
                                              ? AddPlanPage()
                                              : tambahJadwalPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 25,
                      height: 25,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'schedule',
                                  child: Text('Jadwal'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'task',
                                  child: Text('Tugas'),
                                ),
                              ],
                              onSelected: (String value) {
                                setState(() {
                                  _calender = value;
                                  _saveCalender(
                                      _calender); // Simpan nilai _calender
                                  _updateCalenderWidget();
                                });
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 0, // Ukuran ikon yang tidak terlihat
                              ),
                              iconSize: 0, // Ukuran ikon yang tidak terlihat
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          toolbarHeight: 70,
        ),
        body: isLoading ? Center(child: CircularProgressIndicator()) : calender,
      ),
    );
  }
}

class Semester {
  final String title;
  final String time;
  final String id;

  Semester(this.id, this.title, this.time);
}
