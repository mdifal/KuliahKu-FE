import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';
import 'package:kuliahku/ui/widgets/time_field.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:http_parser/http_parser.dart';

import '../widgets/calender/schedule.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({Key? key}) : super(key: key);

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {

  int type = 0;
  int subjectId = 0;
  TextEditingController _judulController = TextEditingController();
  late DateTime _selectedDeadline;
  late DateTime _selectedReminder;
  late DateTime _selectedDeadlineTime;
  late DateTime _selectedReminderTime;
  late String deadlineString = '';
  late String reminderString = '';
  String description = '';
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
    _getDataSource();
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
          String dosen = data['dosen'] ?? '';
          String ruangan = data['ruang'] ?? '';
          DateTime startTime = DateTime.parse(data['startTime']);
          DateTime endTime = DateTime.parse(data['endTime']);
          Color color = Color(data['color']);
          String day = data['day'];

          fetchedMeetings.add(Meeting(id, subject, startTime, endTime, color,
              dosen, ruangan, false, day));
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

  Future<void> addPlanToBackend() async {
    try {
      String url = 'http://$ipUrl:8001/users/$email/rencanaMandiri';

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

      if (_selectedFile != null && _selectedFile!.files.single.bytes != null) {
        var file = _selectedFile!.files.single;
        var bytes = file.bytes!;
        var stream = Stream.fromIterable([bytes]);

        var length = bytes.length;

        var multipartFile = http.MultipartFile(
          'lampiran',
          stream,
          length,
          filename: basename(file.name),
          contentType: MediaType('application', 'octet-stream'),
        );

        requestBody['lampiran'] = multipartFile;
      } else {
        requestBody['lampiran'] = '';
      }

      print(requestBody);

      var response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Rencana mandiri berhasil ditambahkan');
      } else {
        print('Gagal menambahkan rencana mandiri: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 8),
              Text(
                'Tambah Tugas',
                style: TextStyle(
                  color: white,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
                            {
                              'label':'Mengerjakan Tugas',
                              'value': 1
                            },
                            {
                              'label':'Belajar Mandiri',
                              'value': 2
                            }
                          ]
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
                          items: List.generate(meetings.length, (index) {
                            return {
                              'label': meetings[index].eventName,
                              'value': index
                            };
                          }),
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
                          _selectedReminder  = selectedDate;
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
            onPressed: addPlanToBackend,
          ),
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
