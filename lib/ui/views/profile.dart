import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/views/edit_password.dart';
import 'package:kuliahku/ui/views/edit_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kuliahku/ui/views/laporan_hasil_belajar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _username = '';
  late String _fullname = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }
  Future<void> fetchProfileData() async {
    try {
      var url = 'http://$ipUrl:8001/profile/$email';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fetchedData =  json.decode(response.body);

        setState(() {
          _fullname = fetchedData['username'];
          _username = fetchedData['fullname'];
        });
      } else {
        throw Exception('Failed to fetch profile data');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
      throw Exception('Failed to fetch profile data');
    }
  }
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
                  _username,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _fullname,
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
                                  MaterialPageRoute(builder: (context) => const LaporanHasilBelajarPage()),
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
                                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
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
                                  MaterialPageRoute(builder: (context) => const EditPasswordPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.lock_outline), // Tambahkan ikon ke dalam baris
                                  SizedBox(width: 8), // Sisipkan jarak antara ikon dan teks
                                  Text(
                                    'Edit Password',
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
