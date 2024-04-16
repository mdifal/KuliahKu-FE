import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:intl/intl.dart';

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
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showStartTimePicker(context);
                        },
                        child: Text('Jam Mulai: $startTimeString'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showEndTimePicker(context);
                        },
                        child: Text('Jam Selesai: $endTimeString'),
                      ),
                    ),
                  ],
                ),
                CustomDropdown(
                  label: "Hari",
                  placeholder: "Select the day",
                  items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
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

class TimePicker extends StatefulWidget {
  final Function(DateTime) onSave;

  const TimePicker({Key? key, required this.onSave}) : super(key: key);

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          TimePickerSpinner(
            locale: const Locale('en', ''),
            time: dateTime,
            is24HourMode: false,
            isShowSeconds: true,
            itemHeight: 80,
            normalTextStyle: const TextStyle(
              fontSize: 24,
            ),
            highlightedTextStyle:
                const TextStyle(fontSize: 24, color: Colors.blue),
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                dateTime = time;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              widget.onSave(dateTime);
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
