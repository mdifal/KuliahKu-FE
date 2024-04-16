import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

// Fungsi untuk memformat durasi
String formatDuration(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  String hoursString = hours > 0 ? '$hours jam ' : '';
  String minutesString = minutes > 0 ? '$minutes menit ' : '';
  String secondsString = '$remainingSeconds detik';

  return '$hoursString$minutesString$secondsString';
}

// Color getTimeColor(int? seconds) {
//       if (seconds != null) {
//         if (seconds >= 7200){
//           return cardGreen; 
//         }
//         else if (seconds >= 3600) {
//           // Lebih dari atau sama dengan 1 jam
//           return cardBlue; 
//         } else if (seconds > 1800) {
//           // Lebih dari 30 menit
//           return cardYellow;
//         } else if (seconds > 0) {
//           // Lebih dari 0 detik
//           return cardOrange; 
//         }
//       }
//       return Color(0xFF717171); // Grey jika null atau 0
//     }

class CardHistory extends StatelessWidget {
  final String? title;
  final String? mataKuliah;
  final int? time;
  final int? color;

  const CardHistory({Key? key, this.title, this.mataKuliah, this.time, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatDuration(time?? 0); // Mengonversi waktu dalam detik ke format yang diinginkan

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(color!),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                "Mata Kuliah: ",
                style: TextStyle(fontSize: 15),
              ),
              Text(mataKuliah!, style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.access_time_outlined,
                  size: 20,
                ),
              ),
              Text(
                formattedTime,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
