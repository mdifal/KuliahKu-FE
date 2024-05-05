import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';
import 'package:kuliahku/ui/widgets/time_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/global.dart';

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

  List<Map<String, dynamic>> jadwal = [];

  @override
  void initState() {
    super.initState();
    fetchDataJadwal();
    _selectedDeadline = DateTime.now();
    _selectedReminder = DateTime.now();
    _selectedDeadlineTime = DateTime.now();
    updateDeadline(_selectedDeadlineTime);
    _selectedReminderTime = DateTime.now();
    updateReminder(_selectedReminderTime);
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
      // Backend endpoint
      String url = 'http:/$ipUrl:8001/user/$email/rencanaMandiri';

      // Data to be sent to the backend
      Map<String, dynamic> requestBody = {
        'type': type,
        'subjectId': jadwal[subjectId]['id'],
        'title': _judulController.text,
        'dateReminder': DateFormat('yyyy-MM-dd').format(_selectedReminder),
        'timeReminder': DateFormat('HH:mm:ss').format(_selectedReminderTime),
        'dateDeadline': DateFormat('yyyy-MM-dd').format(_selectedDeadline),
        'timeDeadline': DateFormat('HH:mm:ss').format(_selectedDeadlineTime),
        'notes': _catatanController.text,
      };

      if (_selectedFile != null) {
        var file = _selectedFile!.files.single;
        var stream = file.readStream!;
        List<int> bytes = [];
        await for (var chunk in stream) {
          bytes.addAll(chunk);
        }
        String base64File = base64Encode(bytes);
        requestBody['lampiran'] = base64File;
      } else {
        requestBody['lampiran'] = null; // or ''
      }


      print(requestBody);

      var response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
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
        body: Container(
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
                  // Dropdown untuk jenis belajar
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
                        items: List.generate(jadwal.length, (index) {
                          return {
                            'label': jadwal[index]['nama matkul'],
                            'value': index
                          };
                        }),
                      )
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
              CustomButton(
                backgroundColor: yellow,
                label: 'Simpan',
                textColor: white,
                onPressed: () {
                  addPlanToBackend();
                },
              ),
            ],
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
