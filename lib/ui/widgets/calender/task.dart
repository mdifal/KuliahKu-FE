import 'dart:ui';

class Meeting {
  Meeting(this.idEvent, this.eventName, this.from, this.deadline, this.appointmentColor);
  String idEvent;
  String eventName;
  DateTime from;
  DateTime deadline;
  Color appointmentColor;
}
