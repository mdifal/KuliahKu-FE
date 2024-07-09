import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
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
  int _selectedSemester = 1; // Menyimpan semester yang dipilih

  // Fungsi untuk menambahkan semester baru
  Future<void> _addNewSemester() async {
    try {
      final url = Uri.parse('http://$ipUrl/users/$email/semesters');
      final response = await http.post(
        url,
        body: json.encode({
          'semesterNumber': _selectedSemester, // Mengirim semester yang dipilih
          'startDate': _selectedStartDate.toString(),
          'endDate': _selectedEndDate.toString(),
          'totalCredits': _numberOfSubjects,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Jika berhasil menambahkan semester
        print('Semester added successfully');
        // Tampilkan pesan sukses atau navigasi ke halaman lain
      } else {
        // Jika terjadi kesalahan saat menambahkan semester
        print('Failed to add semester');
        // Tampilkan pesan kesalahan
      }
    } catch (error) {
      print('Error adding semester: $error');
      // Tampilkan pesan kesalahan
    }
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
                // Dropdown untuk memilih semester
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
                const SizedBox(height: 20.0),
                CustomDateInput(
                  label: 'Awal Semester',
                  onChanged: (DateTime selectedDate) {
                    setState(() {
                      _selectedStartDate = selectedDate;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                CustomDateInput(
                  label: 'Akhir Semester',
                  onChanged: (DateTime selectedDate) {
                    setState(() {
                      _selectedEndDate = selectedDate;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                CustomNumberInput(
                  label: 'Jumlah SKS',
                  onChanged: (int value) {
                    setState(() {
                      _numberOfSubjects = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30.0),
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
