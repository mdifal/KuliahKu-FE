import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuliahku/ui/shared/style.dart';
import '../widgets/button.dart';
import 'history_time_record.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Data statis untuk ditampilkan di form edit
  String username = 'john_doe';
  String password = '@123john';
  String perguruanTinggi = 'Universitas ABC';
  String dob = '01-01-1990';
  late ImagePicker _imagePicker;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _ambilFoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
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
            SizedBox(height: 20),
            buildEditableFormField(
              initialValue: username,
              labelText: 'Username',
              prefixIcon: Icons.person,
            ),
            SizedBox(height: 20),
            buildEditableFormField(
              initialValue: password,
              labelText: 'Password',
              prefixIcon: Icons.lock,
            ),
            SizedBox(height: 20),
            buildEditableFormField(
              initialValue: perguruanTinggi,
              labelText: 'Perguruan Tinggi',
              prefixIcon: Icons.school,
            ),
            SizedBox(height: 20),
            buildEditableFormField(
              initialValue: dob,
              labelText: 'Date of Birth',
              prefixIcon: Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableFormField({
    required String initialValue,
    required String labelText,
    required IconData prefixIcon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          TextFormField(
            initialValue: initialValue,
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
