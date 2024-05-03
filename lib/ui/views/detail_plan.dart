import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/widgets/calender/task.dart';
import 'package:http/http.dart' as http;

class DetailPlanPage extends StatefulWidget {
  const DetailPlanPage({
    Key? key,
    required this.idTask, // Inisialisasi properti controller
  }) : super(key: key);

  final String idTask;

  @override
  State<DetailPlanPage> createState() => _DetailPlanPageState();
}

class _DetailPlanPageState extends State<DetailPlanPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  late String id = '';
  late String title = '';
  late String type = '';
  late String subjectId = '';
  late String semesterId = '';
  late DateTime dateTimeReminder = DateTime.now();
  late DateTime dateTimeDeadline = DateTime.now();
  late String notes = '';
  late int color = 0;

  Future<void> _fetchData() async {
    var url = 'http://$ipUrl:8001/users/$email/rencanaMandiri/${widget.idTask}';
    print(url);
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
        String statusCode = jsonResponse['statusCode'];
        Map<String, dynamic> data = jsonResponse['data'];
        id = data['id'];
        title = data['title'];
        type = data['type'];
        subjectId = data['subjectId'];
        semesterId = data['semesterId'];
        dateTimeReminder = DateTime.parse(data['dateTimeReminder']);
        dateTimeDeadline = DateTime.parse(data['dateTimeDeadline']);
        notes = data['notes'];
        color = data['color'];
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Detail Plan'),
    ),
    body: ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(id), 
        Text(title), 
      ],
    ),
  );
}

Widget _buildDetailItem(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 4),
      Text(value),
      Divider(), // Add a divider for visual separation
    ],
  );
}
}
