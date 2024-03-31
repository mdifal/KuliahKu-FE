import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:passwordfield/passwordfield.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final bool password;

  const CustomTextField({
    Key? key,
    this.placeholder,
    this.label,
    this.password = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              bottom: 8.0), // Tambahkan margin bawah pada teks
          child: Text(
            label!,
            style: TextStyle(
              color: black,
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (password)
          PasswordField(
            passwordDecoration: PasswordDecoration(
                hintStyle: TextStyle(
              fontSize: 12,
              color: grey,
              fontWeight: FontWeight.w600,
            )),
            backgroundColor: secondaryColor.withOpacity(1),
            passwordConstraint: r'.*[@$#.*].*',
            hintText: placeholder,
            border: PasswordBorder(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: secondaryColor,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 2, color: Colors.red.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: mainColor,
                  width: 1,
                ),
              ),
            ),
            errorMessage: 'must contain special character either . * @ # \$',
          )
        else
          TextField(
            style: TextStyle(
              fontSize: 12,
              color: black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: secondaryColor.withOpacity(0.8),
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 12,
                color: grey.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 21),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: secondaryColor,
                  width: 1,
                ),
              ),
              enabled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: mainColor,
                  width: 1,
                ),
              ),
            ),
          )
      ],
    ));
  }
}
