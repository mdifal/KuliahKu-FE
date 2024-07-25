import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/edit_plan.dart';
import 'package:kuliahku/ui/views/timer.dart';
import 'package:kuliahku/ui/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';


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
  late Map<String, dynamic> plan = {};
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var url = 'http://$ipUrl/users/$email/rencanaMandiri/${widget.idTask}';
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
        print('detail $jsonResponse');
        setState(() {
          Map<String, dynamic> data = jsonResponse['data'];
          plan['id'] = data['id'];
          plan['title'] = data['title'];
          plan['type'] = data['type'];
          plan['subject'] = data['subject'];
          plan['subjectId'] = data['subjectId'];
          plan['dateTimeReminder'] = DateTime.parse(data['dateTimeReminder']);
          plan['dateTimeDeadline'] = DateTime.parse(data['dateTimeDeadline']);
          plan['notes'] = data['notes'];
          plan['color'] = data['color'];
          plan['fileUrl'] = data['fileUrl'] ?? '';

          _isLoading = false;
        });

        print ('ini plan: $plan');

      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> delete() async {
    var url =
        'http://$ipUrl/users/$email/rencanaMandiri/delete/${widget.idTask}';

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
                content: Text('Request failed with status: ${response.statusCode}'),
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
        builder: (context) => UpdateTaskPage(id: widget.idTask, plan: plan),
      ),
    );
  }

  void _openFile(String url) async {
    // Implement file opening logic, for example using url_launcher package
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void deleteTask() async {
    await delete();
    Navigator.pop(context);
    _fetchData();
  }


  void pushToTimer() {
    print ('masuk sini');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerPage(
            subject: plan['subject'],
            subjectId: plan['subjectId'],
            topik: plan['title']
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Plan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator())
          : Container(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 4), // Menambahkan jarak kecil antara title dan type
                      Text(
                        plan['type'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isActiveSemester? mainColor : greySoft,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 25,
                      height: 25,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: updateTask,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: isActiveSemester? mainColor : greySoft,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 25,
                      height: 25,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.delete,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: deleteTask,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateBox('Deadline', plan['dateTimeDeadline']),
                _buildDateBox('Reminder', plan['dateTimeReminder']),
              ],
            ),
            SizedBox(height: 5),
            ListTile(
              leading: Icon(Icons.subject, color: mainColor),
              title: Text(
                'Mata Kuliah',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(plan['subject'], style: TextStyle(fontSize: 14)),
              contentPadding: EdgeInsets.symmetric(vertical: 2),
            ),
            ListTile(
              leading: Icon(Icons.note, color: mainColor),
              title: Text(
                'Catatan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(plan['notes'], style: TextStyle(fontSize: 14)),
              contentPadding: EdgeInsets.symmetric(vertical: 2),
            ),
            if (plan['fileUrl'].isNotEmpty)
              ListTile(
                leading: Icon(Icons.attach_file, color: mainColor),
                title: Text(
                  'Lampiran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(plan['fileUrl'], style: TextStyle(fontSize: 14)),
                onTap: () {
                  // Open file URL or download file
                  _openFile(plan['fileUrl']);
                },
                contentPadding: EdgeInsets.symmetric(vertical: 2),
              ),
            SizedBox(height: 20),
            CustomButton(
              label: 'Start Record',
              backgroundColor: yellow,
              textColor: black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerPage(
                        subject: plan['subject'],
                        subjectId: plan['subjectId'],
                        topik: plan['title']
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBox(String label, DateTime dateTime) {
    String formattedDate = "${dateTime.day.toString().padLeft(2, '0')} ${_monthName(dateTime.month)} ${dateTime.year}";
    String formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
        decoration: BoxDecoration(
          color: softBlue,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'November', 'Agustus', 'September', 'Oktober', 'November', 'Desembar'
    ];
    return months[month - 1];
  }

}
