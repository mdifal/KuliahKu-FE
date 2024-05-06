import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/edit_task.dart';
import 'package:kuliahku/ui/widgets/button.dart';

class DetailPlanPage extends StatefulWidget {
  const DetailPlanPage({
    Key? key,
    required this.idTask,
  }) : super(key: key);

  final String idTask;

  @override
  State<DetailPlanPage> createState() => _DetailPlanPageState();
}

class _DetailPlanPageState extends State<DetailPlanPage> {
  late String id = '';
  late String title = '';
  late String type = '';
  late String subjectId = '';
  late String semesterId = '';
  late DateTime dateTimeReminder = DateTime.now();
  late DateTime dateTimeDeadline = DateTime.now();
  late String notes = '';
  late int color = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

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
        setState(() {});
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> delete() async {
    var url =
        'http://$ipUrl:8001/users/$email/jadwalKuliah/delete/${widget.idTask}';

    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String message = jsonResponse['message'];
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hapus Tugas Berhasil'),
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
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hapus Tugas Gagal'),
                content:
                    Text('Request failed with status: ${response.statusCode}'),
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
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskPage(
          id: widget.idTask,
        ),
      ),
    );
  }

  void deleteTask() {
    delete();
    didChangeDependencies();
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
          _buildDetailItem('ID', id),
          _buildDetailItem('Title', title),
          _buildDetailItem('Type', type),
          _buildDetailItem('Subject ID', subjectId),
          _buildDetailItem('Semester ID', semesterId),
          _buildDetailItem('Reminder', dateTimeReminder.toString()),
          _buildDetailItem('Deadline', dateTimeDeadline.toString()),
          _buildDetailItem('Notes', notes),
          _buildDetailItem('Color', color.toString()),
          Row(
            children: [
              CustomButton(
                  label: 'delete',
                  backgroundColor: Colors.red,
                  textColor: white,
                  onPressed: deleteTask),
              CustomButton(
                  label: 'update',
                  backgroundColor: Color.fromARGB(255, 60, 136, 41),
                  textColor: white,
                  onPressed: updateTask)
            ],
          )
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
