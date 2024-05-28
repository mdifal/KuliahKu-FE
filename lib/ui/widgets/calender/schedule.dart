import 'dart:ui';

class Meeting {
  Meeting(this.id, this.eventName, this.from, this.to, this.background, this.dosen, this.sks, this.ruangan, this.isAllDay, this.day);
  String id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String dosen; 
  int sks;
  String ruangan;
  bool isAllDay;
  String day;
}
