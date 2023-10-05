import 'package:create_event2/provider/journey_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:create_event2/model/journey_data_source.dart';
import 'package:create_event2/page/selectday_viewing_page.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final journeys = Provider.of<JourneyProvider>(context).journeys;
    return SfCalendar(
      view: CalendarView.month,
      dataSource: JourneyDateSource(journeys),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onTap: (details) {
        final provider = Provider.of<JourneyProvider>(context, listen: false);
        provider.setDate(details.date!);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SelectedDayViewingPage()),
        );
        // showModalBottomSheet(
        //     context: context, builder: (context) => const TaskWidget());
      },
    );
  }
}
