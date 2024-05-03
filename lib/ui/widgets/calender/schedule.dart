import 'dart:ui';

import 'package:flutter/material.dart';

class Meeting {
  Meeting(this.eventName, this.day, this.from, this.to, this.background, this.dosen, this.ruangan, this.isAllDay,);
  String eventName;
  String day;
  TimeOfDay from;
  TimeOfDay to;
  Color background;
  String dosen; 
  String ruangan;
  bool isAllDay;
}
