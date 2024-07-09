import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../widgets/calender/schedule.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';
import 'package:kuliahku/ui/widgets/time_field.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:http_parser/http_parser.dart';

class UpdateTaskPage extends StatefulWidget {
  final String id;

  const UpdateTaskPage({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  late int type;
  late int subjectId;
  TextEditingController _judulController = TextEditingController();
  late DateTime _selectedDeadline;
  late DateTime _selectedReminder;
  late DateTime _selectedDeadlineTime;
  late DateTime _selectedReminderTime;
  late String deadlineString = '';
  late String reminderString = '';
  TextEditingController _catatanController = TextEditingController();
  FilePickerResult? _selectedFile;

  List<Meeting> meetings = <Meeting>[];
  DateTime today = DateTime.now();
  late DateTime firstDayOfWeek;
  late DateTime lastDayOfWeek;
  late DateTime startOfFirstDay;
  late DateTime endOfLastDay;
  

  @override
  void initState() {
    super.initState();
    _selectedDeadline = DateTime.now();
    _selectedReminder = DateTime.now();
    _selectedDeadlineTime = DateTime.now();
    updateDeadline(_selectedDeadlineTime);
    _selectedReminderTime = DateTime.now();
    updateReminder(_selectedReminderTime);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    lastDayOfWeek = firstDayOfWeek.add(Duration(days: 5));
    startOfFirstDay =
        DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
    endOfLastDay = DateTime(
        lastDayOfWeek.year, lastDayOfWeek.month, lastDayOfWeek.day, 23, 59, 59);
    _fetchData();
    _fetchDataDetail();
  }

  List<Meeting> _getDataSource() {
    return meetings;
  }

  Future<void> _fetchDataDetail() async {
    var url =
        'http://$ipUrl:8001/users/$email/rencanaMandiri/detail/${widget.id}';

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
        Map<String, dynamic> data = jsonResponse['data'];
        setState(() {
          _judulController.text = data['title'] ?? '';
          type = int.parse(data['type']);
          for (int i = 0; i < meetings.length; i++) {
    print(meetings[i].id);
  }
          subjectId = meetings.indexWhere((meeting) => meeting.id == data['subjectId']);
           
          _selectedDeadline = DateTime.parse(
              data['dateTimeDeadline'] ?? DateTime.now().toString());
          _selectedReminder =
              DateTime.parse(data['dateReminder'] ?? DateTime.now().toString());
          _selectedDeadlineTime = DateTime.parse(
              data['dateTimeDeadline'] ?? DateTime.now().toString());
          _selectedReminderTime = DateTime.parse(
              data['dateTimeReminder'] ?? DateTime.now().toString());
          deadlineString = DateFormat('HH:mm:ss').format(_selectedDeadlineTime);
          reminderString = DateFormat('HH:mm:ss').format(_selectedReminderTime);
          _catatanController.text = data['notes'] ?? '';
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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

  void updateDeadline(DateTime dateTime) {
    setState(() {
      deadlineString = DateFormat('HH:mm:ss').format(dateTime);
    });
  }

  void updateReminder(DateTime dateTime) {
    setState(() {
      reminderString = DateFormat('HH:mm:ss').format(dateTime);
    });
  }

  Future<void> _updateTask() async {
    Map<String, dynamic> requestBody = {
      'type': type,
      'subjectId': meetings[subjectId].id,
      'title': _judulController.text,
      'dateReminder': DateFormat('yyyy-MM-dd').format(_selectedReminder),
      'timeReminder': DateFormat('HH:mm:ss').format(_selectedReminderTime),
      'dateDeadline': DateFormat('yyyy-MM-dd').format(_selectedDeadline),
      'timeDeadline': DateFormat('HH:mm:ss').format(_selectedDeadlineTime),
      'notes': _catatanController.text,
    };

    var url =
        'http://$ipUrl/users/$email/rencanaMandiri/update/${widget.id}';
    var response = await http.put(
      Uri.parse(url),
      body: json.encode(requestBody),
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    String statusCode = jsonResponse['statusCode'];
    String message = jsonResponse['message'];
    if (statusCode == "200") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Tugas Berhasil'),
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
              title: Text('Update Tugas Gagal'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Tugas',
          style: TextStyle(
            color: white,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: darkBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: CustomDropdown(
                      label: "Apa yang akan kamu kerjakan",
                      placeholder: "Pilih jenis belajar",
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                      items: [
                        {'label': 'Mengerjakan Tugas', 'value': 1},
                        {'label': 'Belajar Mandiri', 'value': 2}
                      ],
                      initialValue: type,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: CustomDropdown(
                      label: "Mata Kuliah",
                      placeholder: "Pilih mata kuliah",
                      onChanged: (value) {
                        setState(() {
                          subjectId = value;
                        });
                      },
                      initialValue: subjectId,
                      items: List.generate(
                        meetings.length,
                        (index) {
                          return {
                            'label': meetings[index].eventName,
                            'value': index
                          };
                        },
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: "Judul",
                    password: false,
                    controller: _judulController,
                  ),
                  CustomDateInput(
                    label: 'Deadline',
                    onChanged: (DateTime selectedDate) {
                      setState(() {
                        _selectedDeadline = selectedDate;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomOutlineButton(
                        label: 'Waktu Deadline',
                        value: deadlineString,
                        onPressed: () {
                          _deadlinePicker(context);
                        },
                      ),
                    ],
                  ),
                  CustomDateInput(
                    label: 'Reminder',
                    onChanged: (DateTime selectedDate) {
                      setState(() {
                        _selectedReminder = selectedDate;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomOutlineButton(
                        label: 'Waktu Reminder',
                        value: reminderString,
                        onPressed: () {
                          _reminderPicker(context);
                        },
                      ),
                    ],
                  ),
                  CustomTextField(
                    label: "Catatan",
                    password: false,
                    controller: _catatanController,
                  ),
                  SizedBox(height: 10),
                  CustomUploadFileButton(
                    label: "Tambah Lampiran",
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          _selectedFile = result;
                        });
                      }
                    },
                  ),
                  if (_selectedFile != null)
                    Text(
                      'File: ${_selectedFile!.files.single.name}',
                      style: TextStyle(
                        fontSize: 10,
                        color: delivery,
                        fontFamily: "Poppins",
                      ),
                    ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: CustomButton(
          label: "Simpan",
          backgroundColor: yellow,
          textColor: black,
          onPressed: _updateTask,
        ),
      ),
    );
  }

  void _deadlinePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return TimePicker(
          onSave: (time) {
            setState(() {
              _selectedDeadlineTime = time;
              updateDeadline(_selectedDeadlineTime);
            });
          },
        );
      },
    );
  }

  void _reminderPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return TimePicker(
          onSave: (time) {
            setState(() {
              _selectedReminderTime = time;
              updateReminder(_selectedReminderTime);
            });
          },
        );
      },
    );
  }
}
