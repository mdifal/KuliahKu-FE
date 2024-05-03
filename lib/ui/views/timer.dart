import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'dart:math' as math;

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _seconds = 0;
  bool _isRunning = false;
  late Timer _timer;

  late int _selectedCourse;
  late int _selectedLearningType;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    _isRunning = true;
  }

  void _stopTimer() {
    _timer.cancel();
    _isRunning = false;
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _seconds = 0;
    });
    _isRunning = false;
  }

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
            SizedBox(height: 30),
            _isRunning
                ? Column(
                    children: [
                      Text(
                        'Mata Kuliah: $_selectedCourse',
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
                        label: "Mata Kuliah",
                        placeholder: "Pilih mata kuliah",
                        items: [
                          {'label': 'Basis Data', 'value': 1},
                          {
                            'label': 'Matematika',
                            'value': 2
                          } //nanti valuenya id nya
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCourse = value;
                          });
                        },
                      ),
                      SizedBox(height: 5),
                      CustomDropdown(
                        label: "Jenis Belajar",
                        placeholder: "Pilih jenis belajar",
                        items: [
                          {
                            'label': 'Mengerjakan Tugas',
                            'value': 1
                          },
                          {
                            'label': 'Belajar Mandiri',
                            'value': 2
                          },
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedLearningType = value;
                          });
                        },
                      ),
                    ],
                  ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomIconsButton(
                  label: _isRunning ? 'Stop' : 'Start',
                  iconData: _isRunning ? Icons.stop : Icons.play_arrow,
                  onPressed: _isRunning ? _stopTimer : _startTimer,
                  textColor: Colors.lightBlue,
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 20),
                if (_isRunning) // Tambahkan kondisi ini
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
