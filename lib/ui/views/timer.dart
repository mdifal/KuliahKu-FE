import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  late String _selectedCourseId = '';
  late String _selectedCourseLabel = '';
  late int _selectedLearningTypeId = 1;
  late String _selectedLearningType = '';

  List<Map<String, dynamic>> jadwal = [];
  int type = 0;
  int subjectId = 0;

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
    fetchDataJadwal();
  }

  Future<void> fetchDataJadwal() async {
    try {
      String url = 'http://$ipUrl:8001/users/$email/jadwalKuliah/now';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        List<Map<String, dynamic>> transformedData = fetchedData.map((item) {
          return {
            'id': item['id'].toString(),
            'nama matkul': item['subject'],
          };
        }).toList();

        setState(() {
          jadwal = transformedData;
        });
      } else {
        throw Exception('Failed to load data');
      }

    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void addDataToBackend() async {
    try {
      Map<String, dynamic> data = {
        'startTime': DateFormat('HH:mm:ss').format(_startTime),
        'endTime': DateFormat('HH:mm:ss').format(_endTime),
        'subject': _selectedCourseId,
        'jenis': _selectedLearningTypeId,
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
        title: Text(
          'Timer',
          style: TextStyle(
            color: white,
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.lightBlue,
                      width: 8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formattedTime(_seconds),
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _isRunning || _seconds>0
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
              ],
            )
                : Column(
              children: [
                CustomDropdown(
                  label: "Apa yang akan kamu kerjakan",
                  placeholder: "Pilih jenis belajar",
                  onChanged: (value) {
                    setState(() {
                      _selectedLearningTypeId = value;
                      if(value == 1)
                        _selectedLearningType = 'Mengerjakan Tugas';
                          _selectedLearningType = 'Belajar Mandiri';
                    });
                  },
                  items: [
                    {'label': 'Mengerjakan Tugas', 'value': 1},
                    {'label': 'Belajar Mandiri', 'value': 2}
                  ],
                ),
                CustomDropdown(
                  label: "Mata Kuliah",
                  placeholder: "Pilih mata kuliah",
                  onChanged: (value) {
                    setState(() {
                      _selectedCourseId = jadwal[value]['id'];
                      _selectedCourseLabel = jadwal[value]['nama matkul'];
                    });
                  },
                  items: List.generate(jadwal.length, (index) {
                    return {
                      'label': jadwal[index]['nama matkul'],
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
                    textColor: Colors.lightBlue,
                    backgroundColor: Colors.white,
                  ),
                  if (_isRunning && !_isFinish)
                    CustomIconsButton(
                      label: 'Stop',
                      iconData: Icons.stop ,
                      onPressed: _stopTimer ,
                      textColor: Colors.lightBlue,
                      backgroundColor: Colors.white,
                    ),
                  if (!_isRunning && !_isFinish && _seconds > 0)
                    CustomIconsButton(
                      onPressed: _resetTimer,
                      iconData: Icons.refresh,
                      label: 'Reset',
                      textColor: Colors.lightBlue,
                      backgroundColor: Colors.white,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
