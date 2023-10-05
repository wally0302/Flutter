// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

//import 'package:create_journey2/model/event.dart';
import 'package:create_event2/model/journey.dart';
import 'package:create_event2/model/journey_data_source.dart';
import 'package:create_event2/provider/journey_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:create_event2/page/journey_viewing_page.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JourneyProvider>(context);
    // final selectedJourneys = provider.eventOfSelectedDate;
    /*
    if (selectedJourneys.isEmpty) {
      return Center(
        child: Text(
          'No Journey Found!',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    } else {*/
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      child: SfCalendar(
        showCurrentTimeIndicator: false,
        view: CalendarView.schedule,
        scheduleViewSettings: ScheduleViewSettings(
          appointmentItemHeight: 50,
          //hideEmptyScheduleWeek: true,
          dayHeaderSettings: DayHeaderSettings(
            dayFormat: 'EEEE',
            width: 70,
            dayTextStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            dateTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ),
        dataSource: JourneyDateSource(provider.journeys),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        onTap: (details) {
          if (details.appointments == null) return;
          final journey = details.appointments!.first;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JourneyViewingPage(journey: journey),
            ),
          );
        },
      ),
    );
  }

  Widget buildDateTime(Journey journey) {
    return Column(
      children: [
        if (journey.isAllDay)
          Text(
            '全天',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        if (!journey.isAllDay) buildDate('起始時間：', journey.from),
        if (!journey.isAllDay) buildDate('結束時間：', journey.to),
      ],
    );
  }

  Widget buildDate(String date, DateTime dateTime) {
    final dateString = DateFormat.jm().format(dateTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          date,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(dateString, style: TextStyle(fontSize: 10, color: Colors.white))
      ],
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final journey = details.appointments.first as Journey;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: journey.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              journey.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          buildDateTime(journey)
        ],
      ),
    );
  }
}
