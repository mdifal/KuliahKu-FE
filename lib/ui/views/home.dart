
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/make_new_plan.dart';
import 'package:kuliahku/ui/views/calender.dart';
import 'package:kuliahku/ui/views/history_time_record.dart';
import 'package:kuliahku/ui/views/make_new_schedule.dart';
import 'package:kuliahku/ui/views/profile.dart';
import 'package:kuliahku/ui/views/timer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CalenderTaskandSchedulePage(),
    TimerPage(),
    tambahJadwalPage(),
    ProfilePage(),
    AddPlanPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onItemTapped(4);
        },
        tooltip: 'Tambah Tugas',
        child: Icon(Icons.add),
        backgroundColor: darkBlue,
        foregroundColor: yellow,
        elevation: 0,
        shape: CircleBorder(
          side: BorderSide(color: yellow, width: 5.0, style: BorderStyle.solid),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: darkBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () {
                _onItemTapped(0);
              },
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0 ? Colors.yellow : Colors.white),
              tooltip: 'Home',
            ),
            IconButton(
              onPressed: () {
                _onItemTapped(1);
              },
              icon: Icon(Icons.timer,
                  color: _selectedIndex == 1 ? Colors.yellow : Colors.white),
              tooltip: 'Stopwatch',
            ),
            SizedBox(width: 20),
            IconButton(
              onPressed: () {
                _onItemTapped(2);
              },
              icon: Icon(Icons.chat,
                  color: _selectedIndex == 2 ? Colors.yellow : Colors.white),
              tooltip: 'Chat',
            ),
            IconButton(
              onPressed: () {
                _onItemTapped(3);
              },
              icon: Icon(Icons.person,
                  color: _selectedIndex == 3 ? Colors.yellow : Colors.white),
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}