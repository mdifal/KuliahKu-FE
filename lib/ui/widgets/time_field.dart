import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:intl/intl.dart';

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
          CustomButton(backgroundColor: yellow, label: 'Simpan', textColor: white, onPressed: () {
            widget.onSave(dateTime);
              Navigator.pop(context);
          },)
        ],
      ),
    );
  }
}
