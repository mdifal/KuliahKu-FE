import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/views/edit_password.dart';
import 'package:kuliahku/ui/views/edit_profile.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/views/landing.dart';
import 'dart:convert';
import 'package:kuliahku/ui/views/laporan_hasil_belajar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _username = '';
  late String _fullname = '';
  Stream<Uint8List>? profilePictureStream;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfilePicture();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      var url = 'http://$ipUrl/profile/$email';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fetchedData = json.decode(response.body);

        setState(() {
          _fullname = fetchedData['fullname'];
          _username = fetchedData['username'];

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to fetch profile data');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch profile data');
    }
  }

  Future<void> fetchProfilePicture() async {
    try {
      var url = 'http://$ipUrl/profile/edit/$email/profilePicture';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        if (bytes.isNotEmpty) {
          setState(() {
            profilePictureStream = Stream.value(Uint8List.fromList(bytes));
          });
        } else {
          throw Exception('Empty image data');
        }
      } else {
        throw Exception('Failed to fetch profile picture. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching profile picture: $error');
      throw Exception('Failed to fetch profile picture');
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              StreamBuilder<Uint8List>(
                stream: profilePictureStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: softBlue,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: softBlue,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: softBlue,
                      backgroundImage: MemoryImage(snapshot.data!),
                    );
                  }
                },
              ),

              SizedBox(height: 20),
              isLoading ?
              Container(
                width: 30,
                height: 30,
                child: Center(child: CircularProgressIndicator()),
              )
              : Container(
                child: Column(
                    mainAxisSize: MainAxisSize.min, // Make the Column fit the content
                    children: [
                      Text(
                        _fullname,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _username,
                        style: TextStyle(
                          fontSize: 15,
                          color: grey,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ]
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: white, // Background color
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.2), // Shadow color
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make the Column fit the content
                  children: [
                    MenuItem(
                      icon: Icons.file_copy,
                      text: 'Laporan pembelajaran',
                      color: facebookColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const LaporanHasilBelajarPage()),
                        );
                      },
                    ),
                    Divider(),
                    MenuItem(
                      icon: Icons.edit,
                      text: 'Edit profile',
                      color: facebookColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        );
                      },
                    ),
                    Divider(),
                    MenuItem(
                      icon: Icons.lock_outline,
                      text: 'Ganti Password',
                      color: facebookColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditPasswordPage()),
                        );
                      },
                    ),
                    Divider(),
                    MenuItem(
                      icon: Icons.logout_outlined,
                      text: 'Log Out',
                      color: facebookColor,
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('idSemester');
                        await prefs.remove('idActiveSemester');
                        await prefs.remove('isActiveSemester');
                        await prefs.remove('idSemesterGroup');
                        await prefs.remove('idActiveSemesterGroup');
                        await prefs.remove('isActiveSemesterGroup');
                        await prefs.remove('email');
                        setState(() {
                          idSemester = '';
                          idActiveSemester = '';
                          isActiveSemester = true;
                          idSemesterGroup = '';
                          idActiveSemesterGroup = '';
                          isActiveSemesterGroup = true;
                          email = '';
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  const MenuItem({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
