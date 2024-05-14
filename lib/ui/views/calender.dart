import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/make_new_schedule.dart';
import 'package:kuliahku/ui/widgets/calender_schedule.dart';
import 'package:kuliahku/ui/widgets/calender_task.dart';
import 'package:kuliahku/ui/shared/global.dart';

class CalenderTaskandSchedulePage extends StatefulWidget {
  const CalenderTaskandSchedulePage({super.key});

  @override
  State<CalenderTaskandSchedulePage> createState() =>
      _CalenderTaskandSchedulePageState();
}

class _CalenderTaskandSchedulePageState
    extends State<CalenderTaskandSchedulePage> {
  void ubahsemester() {
    idSemester = 'h';
  }

  Widget calender = CalenderTask();

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semester 2',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      '28  Juni 2023 - 28 Juni 2024',
                      style: TextStyle(fontSize: 13),
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
                                          tambahJadwalPage(), // Ubah ke halaman yang diinginkan
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
        body: calender,
      ),
    );
  }
}
