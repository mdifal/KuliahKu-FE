
import 'dart:ui';

import 'package:kuliahku/ui/widgets/calender/task.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }
  @override
  Color getColor(int index) {
    return appointments![index].appointmentColor;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }
  
}