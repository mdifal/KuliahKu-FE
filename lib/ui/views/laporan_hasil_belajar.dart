import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/images.dart';


class LaporanHasilBelajarPage extends StatefulWidget {
  const LaporanHasilBelajarPage({Key? key}) : super(key: key);

  @override
  _LaporanHasilBelajarPageState createState() => _LaporanHasilBelajarPageState();
}

class _LaporanHasilBelajarPageState extends State<LaporanHasilBelajarPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 8),
              Text(
                'Laporan Hasil Belajar',
                style: TextStyle(
                  color: white,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: darkBlue,
        ),
        body: SafeArea(
          child: ListView(
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
                      fontWeight: FontWeight.w900
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Total jam belajar:',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '859',
                                    style: TextStyle(fontSize: 30), // Ukuran untuk "859"
                                  ),
                                  TextSpan(
                                    text: '/ 900',
                                    style: TextStyle(fontSize: 16), // Ukuran untuk "/ 900"
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Jumlah SKS:',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '20',
                                    style: TextStyle(fontSize: 30), // Ukuran untuk "859"
                                  ),
                                  TextSpan(
                                    text: 'sks',
                                    style: TextStyle(fontSize: 16), // Ukuran untuk "/ 900"
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Waktu produktif:',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: Text(
                              '08.00 - 10.00',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Poppins',
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
