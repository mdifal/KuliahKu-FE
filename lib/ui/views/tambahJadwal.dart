import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:kuliahku/ui/widgets/time_field.dart';

class tambahJadwalPage extends StatefulWidget {
  const tambahJadwalPage({Key? key}) : super(key: key);

  @override
  State<tambahJadwalPage> createState() => _tambahJadwalPageState();
}

class _tambahJadwalPageState extends State<tambahJadwalPage> {
  late DateTime startTime;
  late DateTime endTime;
  late String startTimeString;
  late String endTimeString;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    endTime = DateTime.now();
    updateStartTime(startTime);
    updateEndTime(endTime);
  }

  void updateStartTime(DateTime dateTime) {
    setState(() {
      startTimeString = DateFormat('HH:mm:ss').format(dateTime);
    });
  }

  void updateEndTime(DateTime dateTime) {
    setState(() {
      endTimeString = DateFormat('HH:mm:ss').format(dateTime);
    });
  }

  void _showStartTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return TimePicker(
          onSave: (time) {
            setState(() {
              startTime = time;
              updateStartTime(startTime);
            });
          },
        );
      },
    );
  }

  void _showEndTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return TimePicker(
          onSave: (time) {
            setState(() {
              endTime = time;
              updateEndTime(endTime);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 8),
              Text(
                'Input Jadwal Baru',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: mainColor,
        ),
        body: SingleChildScrollView(
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
              children: [
                CustomTextField(
                  label: "Nama Mata Kuliah",
                  password: false,
                  placeholder: "contoh : basis data",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomOutlineButton(
                            label: 'Jam Mulai',
                            value: startTimeString,
                            onPressed: () {
                              _showStartTimePicker(context);
                            }),CustomOutlineButton(
                            label: 'Jam Selesai',
                            value: endTimeString,
                            onPressed: () {
                              _showEndTimePicker(context);
                            })
                  ],
                ),
                CustomTextField(
                  label: "Dosen Pengampu",
                  password: false,
                  placeholder: "contoh : Bapak fulan",
                ),
                CustomTextField(
                  label: "Ruangan",
                  password: false,
                  placeholder: "contoh : R-109",
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: CustomButton(
            label: "Simpan",
            backgroundColor: yellow,
            textColor: black,
          ),
        ),
      ),
    );
  }
}
