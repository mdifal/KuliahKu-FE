import 'dart:ui';

class Meeting {
  Meeting(this.idEvent, this.eventName, this.from,this.to ,  this.deadline, this.appointmentColor);
  String idEvent;
  String eventName;
  DateTime from;
  DateTime to;
  DateTime deadline;
  Color appointmentColor;
}
