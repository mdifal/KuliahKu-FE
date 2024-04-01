import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
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
  File? _selectedFile;

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
          title: Text(
            'Tambah Tugas',
            style: TextStyle(
              color: white,
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
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
                      items: ['Mengerjakan Tugas', 'Belajar Mandiri'],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: CustomDropdown(
                      key: UniqueKey(),
                      label: "Mata Kuliah",
                      placeholder: "Pilih mata kuliah",
                      items: ['Basis data', 'Matematika'],
                    ),
                  ),
                  CustomDateInput(
                    label: 'Deadline',
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
                  SizedBox(height: 10),
                  CustomUploadFileButton(
                    label: "Tambah Lampiran",
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          _selectedFile = File(result.files.single.path!);
                        });
                      }
                    },
                  ),
                  if (_selectedFile != null)
                    Text(
                      'File: ${basename(_selectedFile!.path)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: delivery
                      ),
                    ),
                  SizedBox(height: 10),
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
