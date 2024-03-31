import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState(); // Perhatikan bahwa ini harus mengembalikan _LandingPageState
}

class _LandingPageState extends State<LandingPage> { // Perhatikan perubahan _LoginPageState menjadi _LandingPageState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor, // Mengatur warna latar belakang
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300, // Sesuaikan dengan tinggi yang diinginkan
              child: Image.asset(
                background_landing,
                fit: BoxFit.cover, // Opsional: mengatur gambar agar memenuhi ukuran kotak
              ),
            ),
            Column(
              children: <Widget>[
                const SizedBox(height: 80.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Kuliah',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: white,
                        ),
                      ),
                      TextSpan(
                        text: 'Ku',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: yellow, // Mengatur warna teks menjadi kuning
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Nikmati kuliahmu, nikmati hidupmu!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: white,// Mengatur warna teks menjadi kuning
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            CustomButton(label: 'login', backgroundColor: white, textColor: black,),
            const SizedBox(height: 30.0),
            CustomButton(label: 'create account', backgroundColor: yellow, textColor: black)
          ],
        ),
      ),
    );
  }
}
