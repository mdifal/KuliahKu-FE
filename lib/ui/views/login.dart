import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/register.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      setState(() {
        if(_errorMessage == "Username tidak boleh kosong"){
          _errorMessage = null;
        }
      });
    });

    _passwordController.addListener(() {
      setState(() {
        if(_errorMessage == "Password tidak boleh kosong"){
          _errorMessage = null;
        }
      });
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String password = _passwordController.text;
    String username = _usernameController.text;

    if (username.isEmpty) {
      setState(() {
        _errorMessage = "Username tidak boleh kosong";
        _isLoading = false;
      });
      return;
    } else if (password.isEmpty) {
      setState(() {
        _errorMessage = "Password tidak boleh kosong";
        _isLoading = false;
      });
      return;
    }

    try {
      Map<String, dynamic> data = {
        "username": username,
        "password": password,
      };

      var response = await http.post(
        Uri.parse('http://$ipUrl/login'),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        String emailId = decodedToken['email'];

        setState(() {
          email = emailId;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (response.statusCode == 401) {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['error'];

        setState(() {
          _errorMessage = errorMessage;
          _isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _errorMessage = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Semantics(
          container: true,
          label: 'Login Page',
          child: Container(
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
                    fit: BoxFit.cover,
                    semanticLabel: 'Background Image',
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
                        Center(
                          child: Column(
                            children: [
                              Semantics(
                                header: true,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: mainColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                'Login untuk melanjutkan perjalananmu!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_errorMessage != null)
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: failed,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        Semantics(
                          label: 'Username Text Field',
                          child: CustomTextField(
                            label: "Username",
                            placeholder: "Enter your Username",
                            controller: _usernameController,
                          ),
                        ),
                        SizedBox(height: 10),
                        Semantics(
                          label: 'Password Text Field',
                          child: CustomTextField(
                            label: "Password",
                            password: true,
                            placeholder: "Enter your password",
                            controller: _passwordController,
                          ),
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
                                    color: mainColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegisterPage()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Semantics(
                          label: 'Login Button',
                          button: true,
                          child: CustomButton(
                            label: 'Login',
                            backgroundColor: yellow,
                            textColor: black,
                            onPressed: _login,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
