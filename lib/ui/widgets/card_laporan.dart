import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/style.dart';

class LaporanItem extends StatelessWidget {
  final String matkul;
  final String jamBelajar;
  final Color color;
  final String? text;
  final String? nilai;
  final Color? scoreColor;

  const LaporanItem({
    required this.matkul,
    required this.jamBelajar,
    required this.color,
    this.text,
    this.nilai,
    this.scoreColor,
  });

  Color getColorFromGrade(String grade) {
    Map<String, Color> gradeColors = {
      'A': cardGreen,
      'AB': cardGreen,
      'B': cardYellow,
      'BC': cardYellow,
      'C': cardOrange,
      'CD': cardOrange,
      'D': cardRed,
      'DE': cardRed,
      'E': failed,
    };

    return gradeColors[grade] ?? mainColor;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle tap action here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: color,
                    border: Border.all(
                      color: blackSoft,
                      width: 1,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        matkul,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                      ),
                      Text(
                        jamBelajar,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                if (nilai != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 20),
                    child: Text(
                      nilai!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),
                  ),
              ],
            ),
            if (text != null)
              Center( // Center widget added here
                child: Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  width: 300,
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: getColorFromGrade(nilai ?? ''),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black, // Set the border color here
                      width: 1.0, // Adjust the width as needed
                    ),
                  ),
                  child: Text(
                    text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
