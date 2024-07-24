import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/card_history.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/widgets/dropdown.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class HistoryRecordPage extends StatefulWidget {
  final String? urlApi;
  const HistoryRecordPage({Key? key, this.urlApi})
      : super(key: key);

  @override
  State<HistoryRecordPage> createState() => _HistoryRecordPageState();
}

class _HistoryRecordPageState extends State<HistoryRecordPage> {
  List<HistoryRecord> histories = <HistoryRecord>[];
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _fetchData() async {
    print('ini link ${widget.urlApi}');
    var url = '${widget.urlApi}';

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
        List<dynamic> dataHistory = jsonResponse['data'];
        List<HistoryRecord> fetchedHistories = <HistoryRecord>[];
        for (var data in dataHistory) {
          String subject = data['subject'];
          String title =  data['title'];
          int time = data['time'];
          int color = data['color'];
          String type = data['type'];
          fetchedHistories.add(HistoryRecord(subject, title, time, color, type));
        }
        setState(() {
          histories = fetchedHistories;
        });
        
      } else {
        print('hai Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
                    color: white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'History Time Record',
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: histories.map((history) {
              return Column(
                children: [
                  CardHistory(
                    type: history.type,
                    title: history.title,
                    mataKuliah: history.subject,
                    time: history.time,
                    color: history.color,
                  ),
                  SizedBox(height: 16),
                ],
              );
            }).toList(),
              ),
            ),
          )),
    );
  }
}

class HistoryRecord {
  final String subject;
  final String title;
  final int time;
  final int color;
  final String type;

  HistoryRecord(this.subject, this.title, this.time, this.color, this.type);
}
