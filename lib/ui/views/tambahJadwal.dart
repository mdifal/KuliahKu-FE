import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class tambahJadwalPage extends StatefulWidget {
  const tambahJadwalPage({super.key});

  @override
  State<tambahJadwalPage> createState() => _tambahJadwalPageState();
}

class _tambahJadwalPageState extends State<tambahJadwalPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('lala'),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: "Nama Mata Kuliah",
                password: false,
                placeholder: "contoh : basis data",
              ),
              Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: CustomDropdown(
                      label: "Hari",
                      placeholder: "Select the day",
                      items: ['Male', 'Female'])),
              Padding(
  padding: EdgeInsets.only(left: 8, right: 8),
  child: Row(
    children: [
      Expanded(
        child: CustomDropdown(
          label: "Hari",
          placeholder: "Jam Mulai",
          items: ['Male', 'Female']
        ),
      ),
      Expanded(
        child: CustomDropdown(
          label: "Hari",
          placeholder: "Jam Selesai",
          items: ['Male', 'Female']
        ),
      ),
    ],
  ),
),
              CustomTextField(
                label: "Dosen Pengampu",
                password: false,
                placeholder: "contoh : Bapak fulan",
              ),
              CustomTextField(
                label: "Ruangan",
                password: false,
                placeholder: "contoh : R-109",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
