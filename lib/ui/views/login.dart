import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/calender.dart';
import 'package:kuliahku/ui/views/register.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

String emailId = '';

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  String? user_id;

  Future<void> _login() async {
    try {
      String password = _passwordController.text;
      String username = _usernameController.text;

      Map<String, dynamic> data = {
        "username": username,
        "password": password,
      };
      print(data);

      var response = await http.post(
        Uri.parse('http://$ipUrl:8001/login'),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        // Token berhasil diterima dari server
        print('Token: $token');

        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

        String email = decodedToken['email'];

        setState(() {
          emailId = email;
        });

        // Lanjutkan navigasi ke halaman AddNewSemesterPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalenderTaskandSchedulePage()),
        );
      } else if (response.statusCode == 401) {
        // Tangani kesalahan autentikasi
        final responseData = json.decode(response.body);
        final errorMessage = responseData['error'];
        print('Gagal login: $errorMessage');

        setState(() {
          _errorMessage = errorMessage; // Atur pesan kesalahan untuk ditampilkan
        });
      } else {
        // Tangani kesalahan lainnya
        print('Error: ${response.statusCode}');
      }

    } catch (error) {
      // Tangani kesalahan jika ada
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: mainColor,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  background_landing,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: Column(children: [
                        Text('Login', style: TextStyle(
                            fontSize: 20,
                            color: mainColor,
                            fontWeight: FontWeight.w600
                        ),),
                        Text('Login untuk melanjutkan perjalananmu!', style: TextStyle(
                            fontSize: 12,
                            color: black,
                            fontWeight: FontWeight.w400
                        ),)
                      ],),),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: _errorMessage != null
                            ? Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: failed,
                            fontSize: 12,
                          ),
                        )
                            : SizedBox(height: 10), // Jika tidak ada pesan kesalahan, biarkan widget kosong
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        label: "Username",
                        placeholder: "Enter your Username",
                        controller: _usernameController,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        label: "Password",
                        password: true,
                        placeholder: "Enter your password",
                        controller: _passwordController,
                      ),
                      SizedBox(height: 80),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: black,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor, // Mengatur warna teks menjadi kuning
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RegisterPage()), // Navigasi ke halaman Register
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        label: 'Login',
                        backgroundColor: yellow,
                        textColor: black,
                        onPressed: _login,
                      )
                    ],
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
