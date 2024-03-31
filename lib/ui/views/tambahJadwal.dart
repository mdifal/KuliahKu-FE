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
          title: Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.white), // Ikon di depan teks
              SizedBox(width: 8), // Spasi antara ikon dan teks
              Text(
                'Input Jadwal Baru',
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
                    CustomTextField(
                      label: "Nama Mata Kuliah",
                      password: false,
                      placeholder: "contoh : basis data",
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: CustomDropdown(
                            label: "Hari",
                            placeholder: "Select the day",
                            items: [
                              'Senin',
                              'Selasa',
                              'Rabu',
                              'Kamis',
                              'Jumat',
                              'Sabtu'
                            ])),
                    Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomDropdown(
                                label: "Jam Mulai",
                                placeholder: "Select the time",
                                items: ['07.00', '08.40']),
                          ),
                          Expanded(
                            child: CustomDropdown(
                                label: "Jam Selesai",
                                placeholder: "Select the time",
                                items: ['07.00', '08.40']),
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
                CustomButton(
                    label: "Simpan", backgroundColor: yellow, textColor: black)
              ],
            )),
      ),
    );
  }
}
