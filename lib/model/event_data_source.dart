import 'package:create_event2/model/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDateSource extends CalendarDataSource {
  EventDateSource(List<Event> appointments) {
    this.appointments = appointments;
  }
  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    return appointments![index].eventStartTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].eventEndTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) => getEvent(index).backgroundColor;
}
