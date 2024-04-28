import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    this.label,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: backgroundColor,
          minimumSize: Size(150, 50),
        ),
        child: Text(
          label!,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CustomIconsButton extends StatelessWidget {
  final String? label;
  final IconData? iconData;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onPressed;

  const CustomIconsButton({
    Key? key,
    this.label,
    this.iconData,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: backgroundColor,
          minimumSize: Size(150, 50),
        ),
        icon: Icon(
          iconData,
          color: textColor,
        ),
        label: Text(
          label!,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CustomUploadFileButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;

  const CustomUploadFileButton({
    Key? key,
    this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 30,
      width: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: white,
        ),
        icon: Icon(Icons.attach_file, color: darkBlue),
        label: Text(
          label!,
          style: TextStyle(
            color: darkBlue,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final String? label;
  final String? value;
  final VoidCallback? onPressed;

  const CustomOutlineButton({
    Key? key,
    this.label,
    this.value,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ), // Tambahkan margin bawah pada teks
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
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: grey),
              ),
              minimumSize: Size(130, 50),
            ),
            child: Text(
              value!,
              style: TextStyle(
                color: grey,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
