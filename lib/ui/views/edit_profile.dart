import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/button.dart';
import '../widgets/editable_form_field.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({Key? key}) :  super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String _username = '';
  late String _fullname = '';
  late String _college = '';
  late DateTime _dob = DateTime(2000, 1, 1); // Default value for _dob
  late ImagePicker _imagePicker;
  XFile? _newImageFile;
  Stream<Uint8List>? profilePictureStream;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _collegeController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  String _statusMessage = '';

  bool isLoading = false;

  void _showStatusMessage(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _fetchInitialData();
  }

  // New method to handle asynchronous work
  Future<void> _fetchInitialData() async {
    try {
      await fetchProfileData();
      await fetchProfilePicture();
    } catch (e) {
      print('Error during initial data fetch: $e');
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
      _newImageFile = pickedFile;
    });
  }

  Future<void> _simpanPerubahan() async {
    try {
      setState(() {
        isLoading = true;
      });

      var url = 'http://$ipUrl/profile/edit/$email';

      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.fields['username'] = _username;
      request.fields['fullname'] = _fullname;
      request.fields['college'] = _college;
      request.fields['dob'] = _dob.toString();

      if (_newImageFile != null) {
        var file = await http.MultipartFile.fromPath('profilePic', _newImageFile!.path);
        request.files.add(file);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        _showStatusMessage('Changes saved successfully');
        print('Perubahan profil disimpan');
      } else {
        throw Exception('Failed to save profile changes');
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('Error saving profile changes: $error');
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to save profile changes');
    }
  }

  Future<XFile?> streamToXFile(Stream<Uint8List> stream) async {
    try {
      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.png';

      // Create a file
      final file = File(filePath);

      // Write stream data to file
      final sink = file.openWrite();
      await for (var chunk in stream) {
        sink.add(chunk);
      }
      await sink.flush();
      await sink.close();

      // Return an XFile instance
      return XFile(filePath);
    } catch (e) {
      print('Error converting stream to XFile: $e');
      return null;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Pass `true` to ensure the previous page reloads
          },
        ),
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
                  _newImageFile != null
                  ?
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(_newImageFile!.path)),
                  )
                  : StreamBuilder<Uint8List>(
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
            if (isLoading)
              Container(
                width: 20,
                height: 30,
                child: Center(child: CircularProgressIndicator()),
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
}
