import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/edit_task.dart';
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
  late String id = '';
  late String title = '';
  late String type = '';
  late String subject = '';
  late DateTime dateTimeReminder = DateTime.now();
  late DateTime dateTimeDeadline = DateTime.now();
  late String notes = '';
  late int color = 0;
  late String fileUrl = '';


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
          id = data['id'];
          title = data['title'];
          type = data['type'];
          subject = data['subject'];
          dateTimeReminder = DateTime.parse(data['dateTimeReminder']);
          dateTimeDeadline = DateTime.parse(data['dateTimeDeadline']);
          notes = data['notes'];
          color = data['color'];
          fileUrl = data['fileUrl'] ?? '';
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
        builder: (context) => UpdateTaskPage(id: widget.idTask),
      ),
    );
  }

  void _openFile(String url) async {
    // Implement file opening logic, for example using url_launcher package
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void deleteTask() async {
    await delete(); // Menghapus data
    Navigator.pop(context); // Kembali ke halaman sebelumnya
    _fetchData(); // Memperbarui data setelah kembali
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
      body: Container(
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
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 4), // Menambahkan jarak kecil antara title dan type
                      Text(
                        type,
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
                                onTap:isActiveSemester? updateTask :() {
                                  
                                },
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
                                onTap: isActiveSemester? deleteTask :() {
                                  
                                },
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
                _buildDateBox('Deadline', dateTimeDeadline),
                _buildDateBox('Reminder', dateTimeReminder),
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
              subtitle: Text(subject, style: TextStyle(fontSize: 14)),
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
              subtitle: Text(notes, style: TextStyle(fontSize: 14)),
              contentPadding: EdgeInsets.symmetric(vertical: 2),
            ),
            if (fileUrl.isNotEmpty)
              ListTile(
                leading: Icon(Icons.attach_file, color: mainColor),
                title: Text(
                  'Lampiran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(fileUrl, style: TextStyle(fontSize: 14)),
                onTap: () {
                  // Open file URL or download file
                  _openFile(fileUrl);
                },
                contentPadding: EdgeInsets.symmetric(vertical: 2),
              ),
            SizedBox(height: 20),
            CustomButton(
              label: 'Start Record',
              backgroundColor: yellow,
              textColor: black,
              onPressed: () {
                // Tambahkan logika untuk mulai merekam
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
