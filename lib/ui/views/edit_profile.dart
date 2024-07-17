import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String _username = '';
  late String _fullname = '';
  late String _college = '';
  late DateTime _dob = DateTime(2000, 1, 1); // Default value for _dob
  late ImagePicker _imagePicker;
  XFile? _imageFile;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _collegeController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  String _statusMessage = '';

  void _showStatusMessage(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      var url = 'http://$ipUrl/profile/edit/$email';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fetchedData = json.decode(response.body);
        print(fetchedData);
        setState(() {
          _username = fetchedData['username'];
          _fullname = fetchedData['fullname'];
          _college = fetchedData['college'] ?? '';
          _dob = fetchedData['dob'] != null ? DateTime.parse(fetchedData['dob']) : DateTime(2000, 1, 1);

          _usernameController.text = _username;
          _fullnameController.text = _fullname;
          _collegeController.text = _college;
          _dobController.text = _dob != null ? DateFormat('yyyy-MM-dd').format(_dob) : '';
        });
      } else {
        throw Exception('Failed to fetch profile data');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
      throw Exception('Failed to fetch profile data');
    }
  }

  Future<void> _ambilFoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _simpanPerubahan() async {
    try {
      var url = 'http://$ipUrl/profile/edit/$email';
      var response = await http.put(
        Uri.parse(url),
        body: jsonEncode({
          'username': _username,
          'fullname': _fullname,
          'college': _college,
          'dob': _dob.toString(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _showStatusMessage('Changes saved successfully');
        print('Perubahan profil disimpan');
      } else {
        throw Exception('Failed to save profile changes');
      }
    } catch (error) {
      print('Error saving profile changes: $error');
      throw Exception('Failed to save profile changes');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _dob) {
      setState(() {
        _dob = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullnameController.dispose();
    _collegeController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: softBlue,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        _ambilFoto();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            buildEditableFormField(
              controller: _usernameController,
              labelText: 'Username',
              prefixIcon: Icons.alternate_email_rounded,
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            SizedBox(height: 10),
            buildEditableFormField(
              controller: _fullnameController,
              labelText: 'Fullname',
              prefixIcon: Icons.person,
              onChanged: (value) {
                setState(() {
                  _fullname = value;
                });
              },
            ),
            SizedBox(height: 10),
            buildEditableFormField(
              controller: _collegeController,
              labelText: 'College',
              prefixIcon: Icons.school,
              onChanged: (value) {
                setState(() {
                  _college = value;
                });
              },
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Stack(
                children: [
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_statusMessage.isNotEmpty)
              Center(
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: success,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 10),
            CustomButton(
              label: "Simpan",
              backgroundColor: yellow,
              textColor: black,
              onPressed: _simpanPerubahan,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: labelText,
              prefixIcon: Icon(prefixIcon),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Implement edit functionality here
              },
            ),
          ),
        ],
      ),
    );
  }
}
