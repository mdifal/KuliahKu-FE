import 'package:flutter/material.dart';

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
                'assets/gambar_landingpage.png',
                fit: BoxFit
                    .cover, // Opsional: mengatur gambar agar memenuhi ukuran kotak
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
                          color: Color(
                              0xFFFFCB46), // Mengatur warna teks menjadi kuning
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
                    color: Colors.white, // Mengatur warna teks menjadi kuning
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.brown[900],
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('NEXT'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.brown[900],
                    backgroundColor: Colors.pink[100],
                    elevation: 8.0,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
