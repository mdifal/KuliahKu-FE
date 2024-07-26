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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Column(
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
                Column(
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
                // // nilai != null ?
                // SizedBox.fromSize(
                //   child: Text(
                //     nilai!,
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.w600,
                //       color: black,
                //     ),
                //   ),
                // ),
              ],
            ),
            // Row(
            //   children: [
            //     Card(
            //       color: scoreColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(7),
            //       ),
            //     )
            //   ],
            // )
          ],
        )
      ),
    );
  }
}
