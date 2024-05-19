import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'edit_password.dart';
import 'edit_profile.dart'; 

class LaporanHasilBelajarPage extends StatefulWidget {
  const LaporanHasilBelajarPage({Key? key}) : super(key: key);

  @override
  _LaporanHasilBelajarPageState createState() => _LaporanHasilBelajarPageState();
}

class _LaporanHasilBelajarPageState extends State<LaporanHasilBelajarPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
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
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make the Column fit the content
                  children: [
                    MenuItem(
                      matkul: 'Laporan pembelajaran',
                      jamBelajar: '80/90',
                      color: facebookColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LaporanHasilBelajarPage()),
                        );
                      },
                    ),
                    Divider(),
                    MenuItem(
                      matkul: 'Edit profile',
                      jamBelajar: '80/90',
                      color: facebookColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                        );
                      },
                    ),
                    Divider(),
                    MenuItem(
                      matkul: 'Edit Password',
                      jamBelajar: '80/90',
                      color: facebookColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditPasswordPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String matkul;
  final String jamBelajar;
  final Color color;
  final VoidCallback onTap;

  const MenuItem({
    required this.matkul,
    required this.jamBelajar,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: color,
                border: Border.all(
                  color: blackSoft,
                  width: 1,
                ),
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matkul,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),
                Text(
                  jamBelajar,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
