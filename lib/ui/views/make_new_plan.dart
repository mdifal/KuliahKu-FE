import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/collab_plan/calender.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/widgets/calender/schedule.dart';
import '../widgets/time_field.dart';
import 'calender.dart';

class AddPlanPage extends StatefulWidget {
  final String? urlApi;
  final String? urlApiMataKuliah;

  const AddPlanPage({Key? key, this.urlApi, this.urlApiMataKuliah});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  int type = 0;
  String subjectId = '';
  final TextEditingController _judulController = TextEditingController();
  late DateTime _selectedDeadline;
  late DateTime _selectedReminder;
  final TextEditingController _catatanController = TextEditingController();
  List<dynamic> meetings = [];
  FilePickerResult? _selectedFile;
  bool _isLoading = false;
  bool _isFetchingData = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _selectedDeadline = DateTime.now();
    _selectedReminder = DateTime.now();
  }

  Future<void> _fetchData() async {
    final url = '${widget.urlApiMataKuliah}';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('data matkul $jsonResponse');
        setState(() {
          meetings = jsonResponse['data'];
          _isFetchingData = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() => _isFetchingData = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isFetchingData = false);
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

  Future<void> addPlanToBackend() async {
    if (type == 0 || subjectId.isEmpty || _judulController.text.isEmpty || _selectedDeadline == null || _selectedReminder == null) {
      _showErrorDialog('Please fill in all required fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = '${widget.urlApi}';
      final request = http.MultipartRequest('POST', Uri.parse(url));

      if (_selectedFile != null && _selectedFile!.files.isNotEmpty) {
        final fileBytes = _selectedFile!.files.first.bytes;
        if (fileBytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: _selectedFile!.files.first.name,
          ));
        } else {
          print('File bytes are null');
        }
      } else {
        print('No file selected');
      }

      request.fields['type'] = type.toString();
      request.fields['subjectId'] = subjectId;
      request.fields['title'] = _judulController.text;
      request.fields['dateReminder'] = DateFormat('yyyy-MM-dd').format(_selectedReminder);
      request.fields['timeReminder'] = DateFormat('HH:mm:ss').format(_selectedReminder);
      request.fields['dateDeadline'] = DateFormat('yyyy-MM-dd').format(_selectedDeadline);
      request.fields['timeDeadline'] = DateFormat('HH:mm:ss').format(_selectedDeadline);
      request.fields['notes'] = _catatanController.text;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Rencana mandiri berhasil ditambahkan');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CalenderCollabPlanPage(calender: 'task', groupId: IdGroup ))
        );
      } else {
        print('Gagal menambahkan rencana mandiri: ${response.statusCode}');
        _showErrorDialog('Error adding plan: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      _showErrorDialog('Error adding plan: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Check Your Inputs',
            style: TextStyle(
                color: black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600
            ),
          ),
          content: Text(
            message,
            style: TextStyle(color: black), // Customize content color
          ),
          backgroundColor: white, // Customize dialog background color
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: mainColor, // Customize button background color
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w400
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tambah Tugas',
            style: TextStyle(
              color: white,
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          backgroundColor: darkBlue,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                ),
                CustomDropdown(
                  label: "Mata Kuliah",
                  placeholder: "Pilih mata kuliah",
                  onChanged: (value) {
                    setState(() {
                      subjectId = meetings[value]['subjectId'];
                    });
                  },
                  isLoading: _isFetchingData,
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
                    onPressed: addPlanToBackend,
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: mainColor, // header background color
            hintColor: mainColor, // selection color
            colorScheme: ColorScheme.light(
              primary: mainColor, // header text and indicator color
              onPrimary: white, // header text color
              onSurface: black, // body text color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: mainColor,
            hintColor: mainColor,
            colorScheme: ColorScheme.light(
              primary: mainColor,
              onPrimary: white,
              onSurface: black,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) onSave(date);
    });
  }
}
