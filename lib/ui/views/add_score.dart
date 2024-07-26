import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/widgets/card_input_nilai.dart';
import 'package:kuliahku/ui/widgets/number_input_field.dart';
import '../widgets/CardLaporan.dart';
import 'add_score.dart';
import 'edit_password.dart';
import 'edit_profile.dart';
import 'laporan_hasil_belajar.dart';

class InputNilaiPage extends StatefulWidget {
  final List<Map<String, dynamic>> laporanItems;

  const InputNilaiPage({Key? key, required this.laporanItems}) : super(key: key);

  @override
  _InputNilaiPageState createState() => _InputNilaiPageState();
}

class _InputNilaiPageState extends State<InputNilaiPage> {
  final TextEditingController ipSemesterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Input Nilai',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: white,
              ),
            ),
          ],
        ),
        backgroundColor: facebookColor,
        iconTheme: IconThemeData(
          color: white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(55, 30, 55, 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'IP Semester',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 25,
                      child: TextField(
                        controller: ipSemesterController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, right: 20, bottom: 20),
                child: ListView.builder(
                  itemCount: widget.laporanItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.laporanItems[index];
                    return Column(
                      children: [
                        Divider(),
                        InputNilaiItem(
                          matkul: item['matkul'],
                          jamBelajar: item['jamBelajar'],
                          color: item['color'],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
