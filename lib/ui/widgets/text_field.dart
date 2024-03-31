import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final bool password;

  const CustomTextField({
    Key? key,
    this.label,
    this.password = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        cursorColor: black,
        style: TextStyle(
          fontSize: 12,
          color: black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: hint),
          counterStyle: TextStyle(
            color: mainColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: greySoft,
              width: 0.0,
            ),
          ),
          enabled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: greySoft,
              width: 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: black,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
