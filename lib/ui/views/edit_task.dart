import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';
import 'package:kuliahku/ui/widgets/time_field.dart';
import 'package:kuliahku/ui/shared/global.dart';

class UpdateTaskPage extends StatefulWidget {
  final String id;

  const UpdateTaskPage({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDataJadwal();
    _selectedDeadline = DateTime.now();
    _selectedReminder = DateTime.now();
    _selectedDeadlineTime = DateTime.now();
    updateDeadline(_selectedDeadlineTime);
    _selectedReminderTime = DateTime.now();
    updateReminder(_selectedReminderTime);
  }

  Future<void> _fetchData() async {
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
          setState(() {
            _judulController.text = data['judul'] ?? ''; // Isi judul dari data
            // Isi nilai untuk elemen-elemen lainnya sesuai dengan data yang diterima
            type = data['type'] ??
                0; // Isi type dari data, jika tidak ada, maka gunakan nilai default 0
            subjectId = data['subjectId'] ??
                0; // Isi subjectId dari data, jika tidak ada, maka gunakan nilai default 0
            _selectedDeadline = DateTime.parse(data['deadline'] ??
                DateTime.now()
                    .toString()); // Isi deadline dari data, jika tidak ada, maka gunakan nilai default DateTime.now()
            _selectedReminder = DateTime.parse(data['reminder'] ??
                DateTime.now()
                    .toString()); // Isi reminder dari data, jika tidak ada, maka gunakan nilai default DateTime.now()
            _selectedDeadlineTime = DateTime.parse(data['deadlineTime'] ??
                DateTime.now()
                    .toString()); // Isi deadlineTime dari data, jika tidak ada, maka gunakan nilai default DateTime.now()
            _selectedReminderTime = DateTime.parse(data['reminderTime'] ??
                DateTime.now()
                    .toString()); // Isi reminderTime dari data, jika tidak ada, maka gunakan nilai default DateTime.now()
            deadlineString = DateFormat('HH:mm:ss').format(
                _selectedDeadlineTime); // Format deadlineTime menjadi string
            reminderString = DateFormat('HH:mm:ss').format(
                _selectedReminderTime); // Format reminderTime menjadi string
            _catatanController.text = data['catatan'] ??
                ''; // Isi catatan dari data, jika tidak ada, maka gunakan string kosong
            // Isi _selectedFile sesuai dengan data yang diterima, jika tidak ada data file, biarkan _selectedFile tetap null
          });
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateTask() async {

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

    String body = jsonEncode(requestBody);
    var url = 'http://$ipUrl:8001/users/$email/rencanaMandiri/update/${widget.id}';
    var response = await http.put(
      Uri.parse(url),
      body: body,
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

  Future<void> fetchDataJadwal() async {
    try {
      String url = 'http://$ipUrl:8001/users/$email/jadwalKuliah/now';
      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 8),
              Text(
                'Update Tugas',
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
                            {'label': 'Mengerjakan Tugas', 'value': 1},
                            {'label': 'Belajar Mandiri', 'value': 2}
                          ]),
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
                        )),
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
