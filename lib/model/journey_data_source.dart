import 'package:create_event2/model/journey.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class JourneyDateSource extends CalendarDataSource {
  JourneyDateSource(List<Journey> appointments) {
    this.appointments = appointments;
  }
  Journey getJourney(int index) => appointments![index] as Journey;

  @override
  DateTime getStartTime(int index) {
    return appointments![index].journeyStartTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].journeyEndTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].journeyName;
  }

  @override
  Color getColor(int index) => getJourney(index).color;

  @override
  bool isAllDay(int index) => getJourney(index).isAllDay;
}
