import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/card_input_nilai.dart';
import '../shared/global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/button.dart';

class InputNilaiPage extends StatefulWidget {
  final List<dynamic> laporanItems;

  const InputNilaiPage({Key? key, required this.laporanItems}) : super(key: key);

  @override
  _InputNilaiPageState createState() => _InputNilaiPageState();
}

class _InputNilaiPageState extends State<InputNilaiPage> {
  final TextEditingController ipSemesterController = TextEditingController();

  String formatedJamBelajar(String actual, String expected) {
    String jamBelajar;

    jamBelajar = actual + '/' + expected;

    return jamBelajar;
  }


  void _updateGrade(int index, String grade) {
    setState(() {
      widget.laporanItems[index]['grade'] = grade;
    });
    print(widget.laporanItems);
  }

  Future<void> _addScore() async {
    try {
      Map<String, dynamic> data = {
        "username": ipSemesterController.text,
        "password": widget.laporanItems,
      };
      print(data);

      var response = await http.post(
        Uri.parse('http://$ipUrl/post'),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        Navigator.pop(context);
      } else if (response.statusCode == 401) {

      } else {
        print('Error: ${response.statusCode}');
      }

    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Input Nilai',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: white,
              ),
            ),
          ],
        ),
        backgroundColor: facebookColor,
        iconTheme: IconThemeData(
          color: white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(55, 30, 55, 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'IP Semester',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 25,
                      child: TextField(
                        controller: ipSemesterController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, right: 20, bottom: 20),
                child:
                ListView.builder(
                  itemCount: widget.laporanItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.laporanItems[index]['dataMatakuliah'];
                    return Column(
                      children: [
                        Divider(),
                        InputNilaiItem(
                          matkul: item['subjectName'],
                          jamBelajar: formatedJamBelajar(widget.laporanItems[index]['hourImplemented'].toString(), widget.laporanItems[index]['hourExpected'].toString()),
                          color: Color(item['subjectColor']),
                          onGradeSelected: (grade) {
                            _updateGrade(index, grade);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10), // Add padding to avoid sticking to the edges
              child: SizedBox(
                height: 50.0, // Adjust height as needed
                width: double.infinity, // Full width button
                child: CustomButton(
                  label: 'Simpan Nilai',
                  backgroundColor: yellow,
                  textColor: black,
                  onPressed: _addScore,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
