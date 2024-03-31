import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: mainColor,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      background_landing,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
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
                        Text('Create Your Account', style: TextStyle(
                          fontSize: 20,
                          color: mainColor,
                          fontWeight: FontWeight.w600
                        ),),
                        Text('Buat akun untuk memulai perjalananmu!', style: TextStyle(
                          fontSize: 12,
                          color: black,
                          fontWeight: FontWeight.w400
                        ),)
                      ],),),
                      CustomTextField(
                        label: "Full Name",
                        password: false,
                        placeholder: "Enter your Full Name",
                      ),
                      CustomTextField(
                        label: "Username",
                        password: false,
                        placeholder: "Enter your Username",
                      ),
                      CustomTextField(
                        label: "Email",
                        password: false,
                        placeholder: "Enter your Email",
                      ),
                      CustomTextField(
                        label: "Password",
                        password: true,
                        placeholder: "Enter your password",
                      ),
                      CustomTextField(
                        label: "Confirm Password",
                        password: true,
                        placeholder: "Confirm your password",
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: black,
                                ),
                              ),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor, // Mengatur warna teks menjadi kuning
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomButton(label:"Sign Up", backgroundColor: yellow , textColor : black)
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
