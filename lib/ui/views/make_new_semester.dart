import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';
import 'package:kuliahku/ui/widgets/number_input_field.dart';

class AddNewSemesterPage extends StatefulWidget {
  const AddNewSemesterPage({Key? key}) : super(key: key);

  @override
  _AddNewSemesterPageState createState() => _AddNewSemesterPageState();
}

class _AddNewSemesterPageState extends State<AddNewSemesterPage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  int _numberOfSubjects = 0;

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
            CustomButton(label: 'Mulai', backgroundColor: mainColor, textColor: white,),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
