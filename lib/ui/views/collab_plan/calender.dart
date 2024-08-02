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
import 'package:kuliahku/ui/views/make_new_semester.dart';
import 'package:kuliahku/ui/views/make_new_subgroup.dart';
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

class _CalenderTaskandSchedulePageState extends State<CalenderCollabPlanPage> {
  DateFormat dateFormat = DateFormat('d MMMM yyyy');
  String nameSubgroup = '';
  String subgroupId = '';
  late Widget calender;
  late String _calender = 'task';
  late bool isLoading = true;
  late Subgroup? activeSubgroup;
  List<Subgroup> subgroups = <Subgroup>[];

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

  Widget contentBox(BuildContext context) {
    return Semantics(
      label: "Dialog to create a new semester",
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.warning_sharp, size: 50, color: Colors.red),
                      SizedBox(height: 15),
                      Text(
                        "Anda Tidak Memiliki Sub Group",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Ayo buat subgroup untuk dapat menggunakan fitur CollabPlan!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addSubgroupPage(
                        groupId: widget.groupId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Buat Subgroup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSubgroup() async {
    activeSubgroup = subgroups.isNotEmpty
        ? (IdSubgroup == ''
            ? subgroups[0]
            : subgroups.firstWhere((subgroup) => subgroup.id == IdSubgroup,
                orElse: () => subgroups[0]))
        : null;
    if (activeSubgroup == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context),
            );
          },
        );
      });
    }
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameSubgroup = activeSubgroup!.name;
      subgroupId = activeSubgroup!.id;
      IdSubgroup = subgroupId;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _fetchData();
    await _loadSubgroup();
    _loadCalender();
  }

  Future<void> _saveCalender(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calender', value);
  }

  Future<void> _saveSubgroup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nameSubgroup', nameSubgroup);
    await prefs.setString('subGroupId', subgroupId);
  }

  void _updateCalenderWidget() {
    if (_calender == 'schedule') {
      calender = CalenderScheduleCollabPlan(groupId: widget.groupId);
    } else {
      calender = CalenderTaskCollabPlan(groupId: widget.groupId);
    }
  }

  void ubahsubgroup(String id) async {
    setState(() {
      IdSubgroup = id;
      final selectedItem = subgroups.firstWhere((item) => item.id == id);
      subgroupId = selectedItem.id;
      nameSubgroup = selectedItem.name;
      isLoading = true;
    });
    await _saveSubgroup();
    await _fetchData();
    setState(() {
      isLoading = false;
    });
  }

  List<Subgroup> _getSubgroup() {
    return subgroups;
  }

  Future<void> _fetchData() async {
    var url = 'http://$ipUrl/groups/${widget.groupId}/subgroups';

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
        List<dynamic> dataSubgroup = jsonResponse['data'];
        List<Subgroup> fetchedSubgroups = <Subgroup>[];

        print('data subgroup $dataSubgroup');
        for (var data in dataSubgroup) {
          String id = data['id'] ?? '';
          String subgroupName = data['name'];

          fetchedSubgroups.add(Subgroup(id, subgroupName));
        }
        setState(() {
          subgroups = fetchedSubgroups;
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
                          nameSubgroup,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    PopupMenuButton<dynamic>(
                      initialValue: subgroups.isNotEmpty
                          ? subgroups.firstWhere(
                              (subgroup) => subgroup.id == IdSubgroup,
                              orElse: () => subgroups.first,
                            )
                          : null,
                      itemBuilder: (BuildContext context) => [
                        ..._getSubgroup().map((Subgroup item) {
                          return PopupMenuItem<Subgroup>(
                            value: item,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name),
                              ],
                            ),
                          );
                        }).toList(),
                        PopupMenuItem<dynamic>(
                          value: 'add',
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Add Subgroup'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (dynamic value) {
                        if (value is Subgroup) {
                          setState(() {
                            ubahsubgroup(value.id);
                          });
                        } else if (value == 'add') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addSubgroupPage(
                                  groupId: widget
                                      .groupId), // Replace with your actual page
                            ),
                          );
                        }
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
                    isActiveSemesterGroup
                        ? Container(
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
                                            builder: (context) => calender
                                                    is CalenderTaskCollabPlan
                                                ? AddPlanPage(
                                                    urlApi:
                                                        'http://$ipUrl/groups/${widget.groupId}/plans',
                                                    urlApiMataKuliah:
                                                        'http://$ipUrl/groups/${widget.groupId}/schedulesList/subgroups/$IdSubgroup/',
                                                  )
                                                : tambahJadwalPage(
                                                    urlApi:
                                                        'http://$ipUrl/groups/${widget.groupId}/schedules',
                                                    subGroupId: IdSubgroup,
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: greySoft,
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
                                      onTap: () {},
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

class Subgroup {
  final String name;
  final String id;

  Subgroup(this.id, this.name);
}
