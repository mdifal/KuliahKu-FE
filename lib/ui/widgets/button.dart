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
      height: 35,
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

class CustomDatetimeButton extends StatelessWidget {
  final String? label;
  final String? dateValue;
  final String? timeValue;
  final VoidCallback? onDatePressed;
  final VoidCallback? onTimePressed;

  const CustomDatetimeButton({
    Key? key,
    this.label,
    this.dateValue,
    this.timeValue,
    this.onDatePressed,
    this.onTimePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: TextStyle(
                color: Colors.black87,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2, // Lebih besar untuk tombol tanggal
                child: TextButton(
                  onPressed: onDatePressed,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.2),
                    elevation: 5,
                    minimumSize: Size(double.infinity, 50), // Atur tinggi minimum
                  ),
                  child: Text(
                    dateValue ?? "Pilih Tanggal",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 10), // Tambahkan spasi antara tombol
              Expanded(
                flex: 1, // Lebih kecil untuk tombol waktu
                child: TextButton(
                  onPressed: onTimePressed,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.2),
                    elevation: 5,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    timeValue ?? "Pilih Jam",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
