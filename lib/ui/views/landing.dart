
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
            CustomButton(label: 'login', color: white),
            const SizedBox(height: 30.0),
            CustomButton(label: 'create account', color: yellow)
          ],
        ),
      ),
    );
  }
}