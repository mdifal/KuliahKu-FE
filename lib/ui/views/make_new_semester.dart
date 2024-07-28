import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/home.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/number_input_field.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/global.dart';


class AddNewSemesterPage extends StatefulWidget {
  const AddNewSemesterPage({Key? key}) : super(key: key);

  @override
  _AddNewSemesterPageState createState() => _AddNewSemesterPageState();
}

class _AddNewSemesterPageState extends State<AddNewSemesterPage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  int _numberOfSubjects = 0;
  int _selectedSemester = 1;
  DateFormat dateFormat = DateFormat('d MMMM yyyy');
  List<Semester> semesters = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var url = 'http://$ipUrl/users/$email/semesters';

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
        List<dynamic> dataSemester = jsonResponse['semesters'];
        List<Semester> fetchedSemesters = <Semester>[];

        print('ini semester $dataSemester');
        for (var data in dataSemester) {
          String id = data['id'] ?? '';
          String semesterName = 'Semester ${data['semesterNumber']}';
          DateTime endDate = DateTime.parse(data['endDate']);
          DateTime startDate = DateTime.parse(data['startDate']);
          String formattedEndDate = dateFormat.format(endDate);
          String formattedStartDate = dateFormat.format(startDate);
          String timeSemester = '$formattedStartDate - $formattedEndDate';

          fetchedSemesters.add(Semester(id, semesterName, timeSemester));
        }
        setState(() {
          semesters = fetchedSemesters;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fungsi untuk menampilkan DatePicker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
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
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  // Fungsi untuk menambahkan semester baru
  Future<void> _addNewSemester() async {
    // Validasi input
    if (_selectedStartDate == null || _selectedEndDate == null) {
      _showErrorDialog('Tanggal awal dan akhir semester tidak boleh kosong');
      return;
    }
    if (_selectedEndDate!.isBefore(_selectedStartDate!)) {
      _showErrorDialog('Tanggal akhir semester tidak boleh sebelum tanggal awal semester');
      return;
    }
    if (_numberOfSubjects <= 0 || _numberOfSubjects > 40) {
      _showErrorDialog('Jumlah SKS harus di antara 1 dan 40');
      return;
    }
    if (semesters.any((semester) => semester.semesterName == 'Semester $_selectedSemester')) {
      _showErrorDialog('Semester ini sudah ada');
      return;
    }

    try {
      final url = 'http://$ipUrl/users/$email/semesters';
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'semesterNumber': _selectedSemester, // Mengirim semester yang dipilih
          'startDate': _selectedStartDate.toString(),
          'endDate': _selectedEndDate.toString(),
          'sks': _numberOfSubjects,
        }),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
      );

      if (response.statusCode == 201) {
        // Jika berhasil menambahkan semester
        print('Semester added successfully');
        // Navigasi ke halaman HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 0)),
        );
      } else {
        // Jika terjadi kesalahan saat menambahkan semester
        print('Failed to add semester');
        _showErrorDialog('Failed to add semester');
      }
    } catch (error) {
      print('Error adding semester: $error');
      _showErrorDialog('Error adding semester: $error');
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
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 40.0),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    image_new_semester,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Mari mulai semester baru!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomDropdown(
                  label: 'Semester',
                  items: List.generate(8, (index) {
                    final semester = index + 1;
                    return {
                      'label': 'Semester $semester',
                      'value': semester
                    };
                  }),
                  placeholder: 'Pilih Semester',
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                CustomNumberInput(
                  label: 'Jumlah SKS',
                  onChanged: (int value) {
                    setState(() {
                      _numberOfSubjects = value;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: CustomOutlineButton(
                          label: 'Awal Semester',
                          value: _selectedStartDate == null
                              ? 'Pilih tanggal'
                              : dateFormat.format(_selectedStartDate!),
                          onPressed: () {
                            _selectDate(context, true);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: CustomOutlineButton(
                          label: 'Akhir Semester',
                          value: _selectedEndDate == null
                              ? 'Pilih tanggal'
                              : dateFormat.format(_selectedEndDate!),
                          onPressed: () {
                            _selectDate(context, false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 20.0),
            // Tombol untuk memulai semester
            CustomButton(
              label: 'Mulai',
              backgroundColor: mainColor,
              textColor: white,
              onPressed: _addNewSemester,
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}

class Semester {
  final String id;
  final String semesterName;
  final String timeSemester;

  Semester(this.id, this.semesterName, this.timeSemester);
}
