import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/input_date.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({Key? key}) : super(key: key);

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  late DateTime _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _selectedDeadline = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Input Plan Baru',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: mainColor,
        ),
        body: Container(
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: Colors.white,
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
                      key: UniqueKey(),
                      label: "Apa yang akan kamu kerjakan",
                      placeholder: "Pilih jenis belajar",
                      items: [
                        'Mengerjakan Tugas',
                        'Belajar Mandiri'
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: CustomDropdown(
                      key: UniqueKey(),
                      label: "Mata Kuliah",
                      placeholder: "Pilih mata kuliah",
                      items: [
                        'Basis data',
                        'Matematika'
                      ],
                    ),
                  ),
                  CustomDateInput(
                    label: 'Batas Waktu',
                    onChanged: (DateTime selectedDate) {
                      setState(() {
                        _selectedDeadline = selectedDate;
                      });
                    },
                  ),
                  CustomTextField(
                    label: "Catatan",
                    password: false,
                  ),
                ],
              ),
              CustomButton(
                label: "Simpan",
                backgroundColor: yellow,
                textColor: black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
