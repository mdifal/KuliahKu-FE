import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/images.dart';
import '../widgets/CardLaporan.dart';
import 'add_score.dart';
import 'edit_password.dart';
import 'edit_profile.dart';

class LaporanHasilBelajarPage extends StatefulWidget {
  const LaporanHasilBelajarPage({Key? key}) : super(key: key);

  @override
  _LaporanHasilBelajarPageState createState() => _LaporanHasilBelajarPageState();
}

class _LaporanHasilBelajarPageState extends State<LaporanHasilBelajarPage> {

  final List<Map<String, dynamic>> laporanItems = [
    {
      'matkul': 'Laporan pembelajaran',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Edit profile',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Edit Password',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Laporan pembelajaran',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Edit profile',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Edit Password',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Laporan pembelajaran',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Edit profile',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
    {
      'matkul': 'Edit Password',
      'jamBelajar': '80/90',
      'color': facebookColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Laporan Hasil Belajar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(5),
            ),
            width: 25,
            height: 25,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InputNilaiPage(laporanItems: laporanItems)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.asset(
                image_laporan_akhir,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Cek laporan belajarmu!',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  color: darkBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 90,
              color: softBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total jam belajar:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '859',
                                style: TextStyle(fontSize: 25),
                              ),
                              TextSpan(
                                text: '/900',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Jumlah SKS:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '20',
                                style: TextStyle(fontSize: 25),
                              ),
                              TextSpan(
                                text: ' sks',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Waktu produktif:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          '08.00 - 10.00',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                child: ListView.builder(
                  itemCount: laporanItems.length,
                  itemBuilder: (context, index) {
                    final item = laporanItems[index];
                    return Column(
                      children: [
                        LaporanItem(
                          matkul: item['matkul'],
                          jamBelajar: item['jamBelajar'],
                          color: item['color'],
                        ),
                        Divider(),
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
