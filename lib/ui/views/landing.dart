import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/views/login.dart';
import 'package:kuliahku/ui/views/register.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainColor,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Image.asset(
                  background_landing,
                  fit: BoxFit.cover,
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
                            fontSize: 52,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                        TextSpan(
                          text: 'Ku',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 52,
                            fontWeight: FontWeight.w600,
                            color: yellow,
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
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80.0),
              CustomButton(
                label: 'Login',
                backgroundColor: white,
                textColor: black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()), // Navigasi ke halaman Register
                  );
                },
              ),
              const SizedBox(height: 10.0),
              CustomButton(
                label: 'Create a new account',
                backgroundColor: yellow,
                textColor: black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()), // Navigasi ke halaman Register
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
