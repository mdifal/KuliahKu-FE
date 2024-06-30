import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';

class TambahGrupPage extends StatefulWidget {
  const TambahGrupPage({Key? key}) : super(key: key);

  @override
  State<TambahGrupPage> createState() => _TambahGrupPageState();
}

class _TambahGrupPageState extends State<TambahGrupPage> {
  TextEditingController namaGrupController = TextEditingController();
  TextEditingController namaAnggotaController = TextEditingController();
  late ImagePicker _imagePicker;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _ambilFoto() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  List<String> daftarEmailAnggota = [
    'nisr@gmail.com',
    'nisaz@gmail.com',
    'nisr@gmail.com',
    'nisaz@gmail.com',
    'nisr@gmail.com',
    'nisaz@gmail.com',
    'nisr@gmail.com',
    'nisaz@gmail.com',
    'nisr@gmail.com',
    'nisaz@gmail.com',
    'nisr@gmail.com',
    'nisaz@gmail.com',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor.withOpacity(0.5),
                      ),
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _ambilFoto,
                        color: mainColor,
                      ),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    onPressed: () {},
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
              ]),
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
                    icon: Icon(Icons.email_outlined),
                    onPressed: () {},
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
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: daftarEmailAnggota.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // Menggunakan CrossAxisAlignment.center untuk menyelaraskan vertikal
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
                                SizedBox(height: 3.0),
                                Divider(color: Colors.grey, thickness: 0.5),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
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
