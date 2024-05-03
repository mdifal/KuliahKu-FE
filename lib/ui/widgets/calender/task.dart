import 'dart:ui';

class Meeting {
  Meeting(this.idEvent, this.eventName, this.date, this.deadline, this.appointmentColor);
  String idEvent;
  String eventName;
  DateTime date;
  DateTime deadline;
  Color appointmentColor;
}
