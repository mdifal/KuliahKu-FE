import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({Key? key}) : super(key: key);

  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  late String _currentPassword = '';
  late String _newPassword = '';
  late String _newPasswordConfirm = '';
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureNewPasswordConfirm = true;

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newPasswordConfirmController = TextEditingController();

  String _statusMessage = '';

  void _showStatusMessage(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  Future<void> _simpanPerubahan() async {
    try {
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      String newPasswordConfirm = _newPasswordConfirmController.text;

      Map<String, dynamic> data = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "password_confirmation": newPasswordConfirm,
      };
      print(data);

      var response = await http.post(
        Uri.parse('http://$ipUrl:8001/profile/edit/password/$email'),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _showStatusMessage('Changes saved successfully');
        print('Password changes saved');
      } else {
        throw Exception('Failed to save password changes');
      }
    } catch (error) {
      // Tangani kesalahan jika ada
      print('Error: $error');
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Edit Password',
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
            buildEditableFormField(
              controller: _currentPasswordController,
              labelText: 'Current Password',
              obscureText: _obscureCurrentPassword,
              onChanged: (value) {
                setState(() {
                  _currentPassword = value;
                });
              },
              onTapToggleVisibility: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
            ),
            SizedBox(height: 10),
            buildEditableFormField(
              controller: _newPasswordController,
              labelText: 'New Password',
              obscureText: _obscureNewPassword,
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
              onTapToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            SizedBox(height: 10),
            buildEditableFormField(
              controller: _newPasswordConfirmController,
              labelText: 'Confirm New Password',
              obscureText: _obscureNewPasswordConfirm,
              onChanged: (value) {
                setState(() {
                  _newPasswordConfirm = value;
                });
              },
              onTapToggleVisibility: () {
                setState(() {
                  _obscureNewPasswordConfirm = !_obscureNewPasswordConfirm;
                });
              },
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
    required bool obscureText,
    required Function(String) onChanged,
    required VoidCallback onTapToggleVisibility,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: labelText,
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onTapToggleVisibility,
            ),
          ),
        ],
      ),
    );
  }
}
