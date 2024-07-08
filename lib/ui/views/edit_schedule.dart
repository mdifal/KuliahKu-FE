import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/home.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/time_field.dart';
import 'package:http/http.dart' as http;

class UpdateSchedulePage extends StatefulWidget {
  final String id;

  const UpdateSchedulePage({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateSchedulePage> createState() => _UpdateSchedulePageState();
}

class _UpdateSchedulePageState extends State<UpdateSchedulePage> {
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  late DateTime startTime;
  late DateTime endTime;
  late String startTimeString;
  late String endTimeString;
  late int selectedColor;
  late int selectedDay;

  TextEditingController _mataKuliahController = TextEditingController();
  TextEditingController _dosenController = TextEditingController();
  TextEditingController _ruanganController = TextEditingController();

  Future<void> _updateSchedule() async {
    String mataKuliah = _mataKuliahController.text;
    String jamMulai = startTimeString;
    String jamSelesai = endTimeString;
    String dosen = _dosenController.text;
    String ruangan = _ruanganController.text;
    int hari = selectedDay;
    int warna = selectedColor;

    Map<String, dynamic> data = {
      "color": warna,
      "day": hari,
      "dosen": dosen,
      "endTime": jamSelesai,
      "ruang": ruangan,
      "startTime": jamMulai,
      "subject": mataKuliah
    };

    String body = jsonEncode(data);
    var url =
        'http://$ipUrl:8001/users/$email/jadwalKuliah/update/${widget.id}';
    var response = await http.put(
      Uri.parse(url),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    String statusCode = jsonResponse['statusCode'];
    String message = jsonResponse['message'];
    if (statusCode == "200") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Jadwal Berhasil'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(calender: 'schedule',)),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Jadwal Gagal'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    }
  }

  Future<void> _fetchData() async {
    var url =
        'http://$ipUrl:8001/users/$email/jadwalKuliah/detail/${widget.id}';

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> data = jsonResponse['data'];
        print('ini data $data');
        setState(() {
          _mataKuliahController.text = data['subject'] ?? '';
          _dosenController.text = data['dosen'] ?? '';
          _ruanganController.text = data['ruang'] ?? '';
          selectedDay = data['day'];
          selectedColor = data['color'];
          startTimeString = data['startTime'];
          endTimeString = data['endTime'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
                'Update Jadwal',
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
                  controller: _mataKuliahController,
                ),
                CustomDropdown(
                  items: [
                    {'label': 'Senin', 'value': 1},
                    {'label': 'Selasa', 'value': 2},
                    {'label': 'Rabu', 'value': 3},
                    {'label': 'Kamis', 'value': 4},
                    {'label': 'Jumat', 'value': 5},
                    {'label': 'Sabtu', 'value': 6},
                    {'label': 'Minggu', 'value': 0},
                  ],
                  label: 'Hari ',
                  placeholder: 'Pilih Hari',
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value;
                    });
                  },
                  initialValue: selectedDay,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomOutlineButton(
                        label: 'Jam Mulai',
                        value: startTimeString,
                        onPressed: () {
                          _showStartTimePicker(context);
                        }),
                    CustomOutlineButton(
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
                  controller: _dosenController,
                ),
                CustomTextField(
                  label: "Ruangan",
                  password: false,
                  placeholder: "contoh : R-109",
                  controller: _ruanganController,
                ),
                CustomDropdown(
                  items: [
                    {'label': 'Merah', 'value': 0xFFD32F2F},
                    {'label': 'Pink', 'value': 0xFFEC407A},
                    {'label': 'Ungu', 'value': 0xFF7B1FA2},
                    {'label': 'Biru', 'value': 0xFF1976D2},
                    {'label': 'Hijau', 'value': 0xFF388E3C},
                    {'label': 'Kuning', 'value': 0xFFFFA000},
                    {'label': 'Orange', 'value': 0xFFFF7043},
                    {'label': 'Abu-Abu', 'value': 0xFF616161},
                  ],
                  label: 'Warna Penanda',
                  placeholder: 'Pilih Warna',
                  onChanged: (value) {
                    setState(() {
                      selectedColor = value;
                    });
                  },
                  initialValue: selectedColor,
                )
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
            onPressed: _updateSchedule,
          ),
        ),
      ),
    );
  }
}
