import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/make_new_semester.dart';
import 'package:kuliahku/ui/views/register.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
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
                      SizedBox(height: 20),
                      CustomTextField(
                        label: "Username",
                        password: false,
                        placeholder: "Enter your Username",
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        label: "Password",
                        password: true,
                        placeholder: "Enter your password",
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddNewSemesterPage()), // Navigasi ke halaman Register
                          );
                        },
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
