import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final Color? color;

  const CustomButton({Key? key, this.label, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize:
            Size(150, 50),
      ),
      child: Text(label!),
    );
  }
}
