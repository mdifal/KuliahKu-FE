import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/views/edit_schedule.dart';
import 'package:kuliahku/ui/widgets/calender/schedule.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/widgets/calender_schedule.dart';

class DetailSchedule extends StatefulWidget {
  final Meeting meeting;
  const DetailSchedule({super.key, required this.meeting});

  @override
  State<DetailSchedule> createState() => _DetailScheduleState();
}

class _DetailScheduleState extends State<DetailSchedule> {
  void updateSchedule(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateSchedulePage(
          id: id,
        ),
      ),
    );
  }

  Future<void> deleteSchedule(String id) async {
    var url = 'http://$ipUrl:8001/users/$email/jadwalKuliah/delete/$id';

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
                title: Text('Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hapus Jadwal Gagal'),
                content:
                    Text('Request failed with status: ${response.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Meeting meeting = widget.meeting;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, meeting),
    );
  }

  contentBox(context, Meeting meeting) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Jadwal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'update',
                child: Text('Update'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (String value) {
              switch (value) {
                case 'update':
                  Navigator.of(context).pop();
                  updateSchedule(meeting.id);
                  
                  break;
                case 'delete':
                  Navigator.of(context).pop();
                  deleteSchedule(meeting.id);
                  didChangeDependencies();
                  break;
              }
            },
            icon: Icon(Icons.more_vert), // Ikon titik tiga
          ),
        ],
      ),
              
              SizedBox(height: 15),
              _buildDetailRow('Mata Kuliah', meeting.eventName),
              _buildDetailRow('Hari', meeting.day),
              _buildDetailRow('Dosen', meeting.dosen),
              _buildDetailRow('Ruangan', meeting.ruangan),
              SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tutup', style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
