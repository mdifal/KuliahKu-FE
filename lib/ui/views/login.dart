
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/images.dart';

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
      backgroundColor: Color(0xFF436CD3), // Mengatur warna latar belakang
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
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Ku',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFCB46), // Mengatur warna teks menjadi kuning
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
                    color: Colors.white,// Mengatur warna teks menjadi kuning
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk tombol Login di sini
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50), // Mengatur ukuran tombol menjadi lebih lebar
              ),
              child: Text('Login'),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk tombol Create Account di sini
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow, // Mengatur warna tombol menjadi kuning
                minimumSize: Size(150, 50), // Mengatur ukuran tombol menjadi lebih lebar
              ),
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}