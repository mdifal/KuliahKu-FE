import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    _isRunning = true;
  }

  void _pauseTimer() {
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
          ), // Set color of AppBar text to white
        ),
        iconTheme: IconThemeData(color: white),
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
                      color: lightBlue,
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
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomIconsButton(
                  label: _isRunning ? 'Pause' : 'Start',
                  iconData: _isRunning ? Icons.pause : Icons.play_arrow,
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  textColor: lightBlue,
                  backgroundColor: white,
                ),
                SizedBox(width: 20),
                CustomIconsButton(
                  onPressed: _resetTimer,
                  iconData: Icons.refresh,
                  label: 'Reset',
                  textColor: lightBlue,
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