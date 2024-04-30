import 'dart:ui';

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.dosen, this.ruangan, this.isAllDay);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String dosen; 
  String ruangan; 
  bool isAllDay;
}
