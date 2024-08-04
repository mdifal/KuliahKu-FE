import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/views/collab_plan/calender.dart';
import 'package:kuliahku/ui/views/edit_schedule.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/widgets/calender/schedule.dart';
import 'package:kuliahku/ui/widgets/calender_schedule.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DetailSchedule extends StatefulWidget {
  final Meeting meeting;
  final String? GroupId;
  const DetailSchedule({super.key, required this.meeting, this.GroupId});

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
          urlApi: 'http://$ipUrl/groups/${widget.GroupId}/schedules/$id',
        ),
      ),
    );
  }

  Future<void> deleteSchedule(String id) async {
    var url = '';
    if (widget.GroupId == null) {
      url = 'http://$ipUrl/users/$email/jadwalKuliah/delete/$id';
    } else {
      url = 'http://$ipUrl/groups/${widget.GroupId}/schedules/$id';
    }
    print('url $url');
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
      } else {
        print('Request failed with status: ${response.statusCode}');
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
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, meeting),
    );
  }

  Widget contentBox(context, Meeting meeting) {
    final DateFormat timeFormat = DateFormat('HH:mm');
    final String startTime = timeFormat.format(meeting.from);
    final String endTime = timeFormat.format(meeting.to);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Text('Mata Kuliah',
                                  style: TextStyle(fontSize: 12)),
                              Text(meeting.eventName.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                          SizedBox(width: 8),
                          Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                                side: BorderSide(color: mainColor, width: 1),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 12),
                                child: Column(
                                  children: [
                                    Text('SKS', style: TextStyle(fontSize: 8)),
                                    Text(meeting.sks.toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Card(
                      color: Colors.blueAccent.withOpacity(0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                meeting.day +
                                    ", " +
                                    '${startTime} - ${endTime}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Card(
                      color: Colors.blueAccent.withOpacity(0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(
                                Icons.person, 'Dosen', meeting.dosen),
                            SizedBox(height: 10),
                            _buildDetailRow(
                                Icons.room, 'Ruangan', meeting.ruangan),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isActiveSemester
                  ? Positioned(
                      right: 0,
                      child: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
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
                        icon: Icon(Icons.more_vert, color: Colors.grey),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tutup',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 10),
        Text(
          " :   " + value,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
