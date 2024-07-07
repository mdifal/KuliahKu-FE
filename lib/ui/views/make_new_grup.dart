import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TambahGrupPage extends StatefulWidget {
  const TambahGrupPage({Key? key}) : super(key: key);

  @override
  State<TambahGrupPage> createState() => _TambahGrupPageState();
}

class _TambahGrupPageState extends State<TambahGrupPage> {
  TextEditingController namaGrupController = TextEditingController();
  TextEditingController namaAnggotaController = TextEditingController();
  late ImagePicker _imagePicker;
  File? _imageFile;
  String errorText = '';
  List<String> daftarEmailAnggota = [];

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _ambilFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  bool _isEmailValid(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void tambahAnggota() {
    final _email = namaAnggotaController.text;
    if (_email.isEmpty) {
      setState(() {
        errorText = 'Email tidak boleh kosong';
      });
    } else if (!daftarEmailAnggota.contains(_email)) {
      if (_isEmailValid(email)) {
        if (_email == '$email') {
          setState(() {
            errorText = 'Tidak boleh menambahkan diri anda sendiri';
          });
        } else {
          setState(() {
            daftarEmailAnggota.add(_email);
            namaAnggotaController.clear();
            errorText = ''; // Clear error text on successful addition
          });
        }
      } else {
        setState(() {
          errorText = 'Format email tidak valid';
        });
      }
    } else {
      setState(() {
        errorText = 'Email sudah ada dalam daftar';
      });
    }
  }

  Future<File> _loadDefaultImage() async {
    final byteData = await rootBundle.load('$image_group_default');
    final tempFile =
        File('${(await getTemporaryDirectory()).path}/default_image.png');
    return await tempFile.writeAsBytes(byteData.buffer.asUint8List());
  }

  Future<void> addGroup(BuildContext context) async {
    try {
      String namaGroup = namaGrupController.text;
      List<String> daftarAnggota = daftarEmailAnggota;
      File imageFile;
      var url = 'http://$ipUrl:8001/groups/$email';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      if (_imageFile != null && _imageFile!.existsSync()) {
        imageFile = _imageFile!;
      } else {
        imageFile = await _loadDefaultImage();
      }

      var stream = http.ByteStream(imageFile.openRead().cast());
      var length = await imageFile.length();

      request.files.add(http.MultipartFile(
        'picture',
        stream,
        length,
        filename: basename(imageFile.path),
      ));

      if (daftarAnggota.isEmpty) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Tambahkan minimal 1 teman anda!",
            backgroundColor: failed,
          ),
        );
        return;
      }

      if (namaGroup.isEmpty) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Nama Grup Tidak Boleh Kosong!",
            backgroundColor: failed,
          ),
        );
        return;
      }

      request.fields['groupName'] = namaGroup;
      request.fields['participants'] = jsonEncode(daftarAnggota);

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Grup Berhasil Dibuat!",
            backgroundColor: success,
          ),
        );
        setState(() {
          namaGrupController.clear();
          namaAnggotaController.clear();
          daftarEmailAnggota.clear();
          _imageFile = null;
        });
      } else {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Grup Gagal Dibuat!",
            backgroundColor: failed,
          ),
        );
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 8),
            Text(
              'Grup Baru',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: mainColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: softBlue,
                        backgroundImage: _imageFile != null
                            ? FileImage(File(_imageFile!.path))
                            : null,
                      ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            _ambilFoto();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: CustomTextFieldNoLabel(
                      password: false,
                      placeholder: "Nama Grup",
                      controller: namaGrupController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Anggota",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: () {
                      addGroup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: yellow,
                      minimumSize: Size(70, 30),
                    ),
                    child: Text(
                      'Buat Grup',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            TextField(
              controller: namaAnggotaController,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: tambahAnggota,
                  color: mainColor,
                  iconSize: 18,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Masukkan Email Temanmu!",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: secondaryColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 1,
                  ),
                ),
                errorText: errorText.isNotEmpty ? errorText : null,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(15.0),
                  child: daftarEmailAnggota.isEmpty
                      ? Center(
                          child: Text(
                            'Ayo Tambahkan Anggota',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : Column(
                          children:
                              List.generate(daftarEmailAnggota.length, (index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                secondaryColor.withOpacity(0.5),
                                          ),
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.person_outline,
                                              color: mainColor),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          daftarEmailAnggota[index],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          daftarEmailAnggota.removeAt(index);
                                        });
                                      },
                                      color: mainColor,
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.grey, thickness: 0.5),
                              ],
                            );
                          }),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
