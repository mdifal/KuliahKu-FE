import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/calender.dart';
import 'package:kuliahku/ui/views/history_time_record.dart';
import 'package:kuliahku/ui/views/profile.dart';
import 'package:kuliahku/ui/views/timer.dart';
import 'package:kuliahku/ui/views/chat.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';

class HomePage extends StatefulWidget {
  final int? initialIndex;
  final String? calender;

  const HomePage({Key? key, this.initialIndex, this.calender}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  late String? _calender;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
    _calender = widget.calender ?? 'task';

    _pages = [
      CalenderTaskandSchedulePage(calender: _calender),
      HistoryRecordPage(urlApi: 'http://$ipUrl/users/$email/time-records/semester/$idSemester'),
      ChatPage(),
      ProfilePage(),
      TimerPage(urlApi: 'http://$ipUrl/users/$email/time-records', urlApiHistory: 'http://$ipUrl/users/$email/time-records/semester/$idSemester', urlApiMataKuliah: 'http://$ipUrl/users/$email/jadwalKuliahList/now',),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent the FloatingActionButton from moving when the keyboard is open
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
        child: _pages[_selectedIndex],
      ),
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
              icon: Icon(Icons.chat_outlined,
                  color: _selectedIndex == 2 ? Colors.yellow : Colors.white),
              tooltip: 'Jadwal',
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
