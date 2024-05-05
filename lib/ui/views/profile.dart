import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

import '../widgets/button.dart';
import 'history_time_record.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Profile',
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
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: softBlue,
                      // backgroundImage: AssetImage(''),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'username',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Nama lengkap',
                  style: TextStyle(
                    fontSize: 18,
                    color: grey,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 50),
                Expanded(
                  child: Container(
                    width: 300,
                    child: Table(
                      border: TableBorder.all(color: disable),
                      children: [
                        TableRow(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HistoryRecordPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.file_copy), // Tambahkan ikon ke dalam baris
                                  SizedBox(width: 8), // Sisipkan jarak antara ikon dan teks
                                  Text(
                                    'Laporan pembelajaran',
                                    style: TextStyle(color: Colors.black), // Atur warna teks sesuai kebutuhan
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HistoryRecordPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.edit), // Tambahkan ikon ke dalam baris
                                  SizedBox(width: 8), // Sisipkan jarak antara ikon dan teks
                                  Text(
                                    'Edit profile',
                                    style: TextStyle(color: Colors.black), // Atur warna teks sesuai kebutuhan
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HistoryRecordPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.logout), // Tambahkan ikon ke dalam baris
                                  SizedBox(width: 8), // Sisipkan jarak antara ikon dan teks
                                  Text(
                                    'Log out',
                                    style: TextStyle(color: Colors.black), // Atur warna teks sesuai kebutuhan
                                  ),
                                ],
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
        ],
      ),
    );
  }
}
