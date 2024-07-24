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

import '../widgets/editable_form_field.dart';
import 'calender.dart';

class UpdateTaskPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> plan;

  const UpdateTaskPage({Key? key, required this.id, required this.plan}) : super(key: key);

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  int type = 0;
  String subjectId = '';
  final TextEditingController _judulController = TextEditingController();
  late DateTime _selectedDeadline;
  late DateTime _selectedReminder;
  final TextEditingController _catatanController = TextEditingController();
  List<dynamic> meetings = [];
  FilePickerResult? _selectedFile;
  bool _isLoadingMatkul = true;

  @override
  void initState() {
    super.initState();
    _fetchDataMatkul();
    _selectedDeadline = DateTime.now();
    _selectedReminder = DateTime.now();
    type = widget.plan['type'] == 'Mengerjakan Tugas' ? 1 : 2 ;
    _selectedReminder = widget.plan['dateTimeReminder'];
    _selectedDeadline = widget.plan['dateTimeDeadline'];
    _catatanController.text = widget.plan['notes'];
    _judulController.text = widget.plan['title'];
  }

  Future<void> _fetchDataMatkul() async {
    final url = 'http://$ipUrl/users/$email/jadwalKuliahList/now';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          meetings = jsonResponse['data'];
          _isLoadingMatkul = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() => _isLoadingMatkul = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoadingMatkul = false);
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result;
      });
    } else {
      print('Tidak ada file yang dipilih');
    }
  }

  Future<void> _updateTask() async {
    print (subjectId);
    Map<String, dynamic> requestBody = {
      'type': type != 0 ? type : widget.plan['type'],
      'subjectId': subjectId != '' ? subjectId : widget.plan['subjectId'] ?? 'abcde',
      'title': _judulController.text,
      'dateReminder': DateFormat('yyyy-MM-dd').format(_selectedReminder),
      'timeReminder': DateFormat('HH:mm:ss').format(_selectedReminder),
      'dateDeadline': DateFormat('yyyy-MM-dd').format(_selectedDeadline),
      'timeDeadline': DateFormat('HH:mm:ss').format(_selectedDeadline),
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
    return MaterialApp(
      home: Scaffold(
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
        body:
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDropdown(
                  label: "Apa yang akan kamu kerjakan",
                  placeholder: widget.plan['type'],
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                  items: [
                    {'label': 'Mengerjakan Tugas', 'value': 1},
                    {'label': 'Belajar Mandiri', 'value': 2}
                  ],
                ),
                CustomDropdown(
                  label: "Mata Kuliah",
                  placeholder: widget.plan['subject'],
                  onChanged: (value) {
                    setState(() {
                      subjectId = meetings[value]['subjectId'];
                    });
                  },
                  isLoading: _isLoadingMatkul,
                  items: List.generate(meetings.length, (index) {
                    return {'label': meetings[index]['subject'], 'value': index};
                  }),
                ),
                CustomTextField(
                  label: "Judul",
                  password: false,
                  controller: _judulController,
                ),
                CustomDatetimeButton(
                  label: 'Deadline',
                  dateValue: DateFormat('dd/MM/yyyy').format(_selectedDeadline),
                  timeValue: DateFormat('HH:mm').format(_selectedDeadline),
                  onDatePressed: () => _pickDate(context, (date) {
                    setState(() {
                      _selectedDeadline = DateTime(date.year, date.month, date.day, _selectedDeadline.hour, _selectedDeadline.minute);
                    });
                  }),
                  onTimePressed: () => _pickTime(context, (time) {
                    setState(() {
                      _selectedDeadline = DateTime(_selectedDeadline.year, _selectedDeadline.month, _selectedDeadline.day, time.hour, time.minute);
                    });
                  }),
                ),
                CustomDatetimeButton(
                  label: 'Reminder',
                  dateValue: DateFormat('dd/MM/yyyy').format(_selectedReminder),
                  timeValue: DateFormat('HH:mm').format(_selectedReminder),
                  onDatePressed: () => _pickDate(context, (date) {
                    setState(() {
                      _selectedReminder = DateTime(date.year, date.month, date.day, _selectedReminder.hour, _selectedReminder.minute);
                    });
                  }),
                  onTimePressed: () => _pickTime(context, (time) {
                    setState(() {
                      _selectedReminder = DateTime(_selectedReminder.year, _selectedReminder.month, _selectedReminder.day, time.hour, time.minute);
                    });
                  }),
                ),
                CustomTextField(
                  label: "Catatan",
                  password: false,
                  controller: _catatanController,
                ),
                SizedBox(height: 10),
                CustomUploadFileButton(
                  label: "Tambah Lampiran",
                  onPressed: _pickFile,
                ),
                if (_selectedFile != null)
                  Text(
                    'File: ${_selectedFile!.files.first.name}',
                    style: TextStyle(fontSize: 10, color: black, fontFamily: "Poppins"),
                  ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: CustomButton(
                    label: "Simpan",
                    backgroundColor: yellow,
                    textColor: black,
                    onPressed: _updateTask,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickTime(BuildContext context, ValueChanged<TimeOfDay> onSave) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    ).then((time) {
      if (time != null) onSave(time);
    });
  }

  void _pickDate(BuildContext context, ValueChanged<DateTime> onSave) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((date) {
      if (date != null) onSave(date);
    });
  }
}
