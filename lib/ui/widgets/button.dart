import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton(
      {Key? key, this.label, this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () {
            // Logika untuk saat tombol ditekan
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Ubah nilai sesuai kebutuhan Anda
            ),
            backgroundColor: backgroundColor,
            minimumSize: Size(150, 50),
          ),
          child: Text(
            label!,
            style: TextStyle(color: textColor), // Warna teks putih
          ),
        ));
  }
}
