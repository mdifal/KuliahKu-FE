import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/widgets/calender/schedule.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/text_field.dart';
import 'history_time_record.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _seconds = 0;
  bool _isRunning = false;
  bool _isFinish = false;
  late Timer _timer;

  late DateTime _startTime;
  late DateTime _endTime;

  TextEditingController _judulController = TextEditingController();
  String _judulText = '';

  late String _selectedCourseId = '';
  late String _selectedCourseLabel = '';
  late int _selectedLearningTypeId = 2;
  late String _selectedLearningType = 'Belajar Mandiri';

  int type = 0;
  int subjectId = 0;

  List<Meeting> meetings = <Meeting>[];
  DateTime today = DateTime.now();
  late DateTime firstDayOfWeek;
  late DateTime lastDayOfWeek;
  late DateTime startOfFirstDay;
  late DateTime endOfLastDay;

  String _formattedTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
    _getDataSource();

    _judulController.addListener(() {
      setState(() {
        _judulText = _judulController.text;
      });
    });
  }

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
          int sks = data['sks'];
          String dosen = data['dosen'] ?? '';
          String ruangan = data['ruang'] ?? '';
          DateTime startTime = DateTime.parse(data['startTime']);
          DateTime endTime = DateTime.parse(data['endTime']);
          Color color = Color(data['color']);
          String day = data['day'];

          fetchedMeetings.add(Meeting(id, subject, startTime, endTime, color,
              dosen, sks, ruangan, false, day));
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

  void addDataToBackend() async {
    try {
      Map<String, dynamic> data = {
        'startTime': DateFormat('HH:mm:ss').format(_startTime),
        'endTime': DateFormat('HH:mm:ss').format(_endTime),
        'subject': _selectedCourseId,
        'title' : _judulController.text,
        'type': _selectedLearningTypeId,
        'time_records': _formattedTime(_seconds),
      };

      String url = 'http://$ipUrl:8001/users/$email/time-records';
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print(data);

      if (response.statusCode == 201) {
        print('Time record added successfully');

        setState(() {
          _isFinish = false;
          _isRunning = false;
          _seconds = 0;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryRecordPage()),
        );
      } else {
        throw Exception('Failed to add time record');
      }
    } catch (error) {
      print('Error adding time record: $error');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    setState(() {
      _isRunning = true;
      if(_seconds<=0)
        _startTime = DateTime.now();
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isFinish = true;
      _endTime = DateTime.now();
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Record',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.history,
              color: white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryRecordPage()),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: mainColor,
                      width: 8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formattedTime(_seconds),
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            _isRunning || _seconds > 0
                ? Column(
              children: [
                Text(
                  'Mata Kuliah: $_selectedCourseLabel',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Jenis Belajar: $_selectedLearningType',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Topik: $_judulText',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
                : Column(
              children: [
                CustomTextField(
                  label: "Topik Belajar",
                  password: false,
                  controller: _judulController,
                ),
                CustomDropdown(
                  label: "Mata Kuliah",
                  placeholder: "Pilih mata kuliah",
                  onChanged: (value) {
                    setState(() {
                      _selectedCourseId = meetings[value].id;
                      _selectedCourseLabel = meetings[value].eventName;
                    });
                  },
                  items: List.generate(meetings.length, (index) {
                    return {
                      'label': meetings[index].eventName,
                      'value': index
                    };
                  }),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if(_isFinish)
                  CustomButton(
                    backgroundColor: yellow,
                    label: 'Simpan',
                    textColor: white,
                    onPressed: () {
                      addDataToBackend();
                    },
                  ),
                if (!_isFinish)
                  CustomIconsButton(
                    label: _isRunning ? 'Pause' : 'Start',
                    iconData: _isRunning ? Icons.pause: Icons.play_arrow,
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    textColor: mainColor,
                    backgroundColor: white,
                  ),
                  if (_isRunning && !_isFinish)
                    CustomIconsButton(
                      label: 'Stop',
                      iconData: Icons.stop ,
                      onPressed: _stopTimer ,
                      textColor: mainColor,
                      backgroundColor: white,
                    ),
                  if (!_isRunning && !_isFinish && _seconds > 0)
                    CustomIconsButton(
                      onPressed: _resetTimer,
                      iconData: Icons.refresh,
                      label: 'Reset',
                      textColor: mainColor,
                      backgroundColor: white,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
