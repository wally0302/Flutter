//當天日期的活動與行程
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/utils.dart';
import 'package:create_event2/page/journey_editing_page.dart';
import 'package:create_event2/provider/journey_provider.dart';
import '../provider/event_provider.dart';
import 'package:create_event2/model/journey.dart';
import '../model/event.dart';
import 'package:create_event2/page/journey_viewing_page.dart';
import 'event_viewing_page.dart';

class SelectedDayViewingPage extends StatefulWidget {
  const SelectedDayViewingPage({
    super.key,
  });

  @override
  State<SelectedDayViewingPage> createState() => _SelectedDayViewingPageState();
}

class _SelectedDayViewingPageState extends State<SelectedDayViewingPage> {
  @override
  void initState() {
    super.initState();
    fetchSelectedDayJourneyAndEvent();
  }

  //  從 JourneyProvider & EventProvider 中獲取"當天"的"行程"和"活動"，並合併為一個列表
  List<dynamic> selectedDayItems = [];

  void fetchSelectedDayJourneyAndEvent() {
    final journeyProvider =
        Provider.of<JourneyProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    final selectedDate = journeyProvider.selectedDate; //日期

    // 這也是一個 List
    final allJourneys = journeyProvider.getJourneys();
    final allActivities = eventProvider.getEvents();

    selectedDayItems.clear();

    //判斷是否為今天，是的話就加入 list
    selectedDayItems.addAll(allJourneys.where((journey) {
      final startDateTime = journey.journeyStartTime;
      final endDateTime = journey.journeyEndTime;
      final startDate = DateTime(
        startDateTime.year,
        startDateTime.month,
        startDateTime.day,
      );
      final endDate = DateTime(
        endDateTime.year,
        endDateTime.month,
        endDateTime.day,
      );

      return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          selectedDate.isBefore(endDate.add(Duration(days: 1)));
    }));

    selectedDayItems.addAll(allActivities.where((event) {
      final startDateTime = event.eventStartTime;
      final endDateTime = event.eventEndTime;
      final startDate = DateTime(
        startDateTime.year,
        startDateTime.month,
        startDateTime.day,
      );
      final endDate = DateTime(
        endDateTime.year,
        endDateTime.month,
        endDateTime.day,
      );

      return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          selectedDate.isBefore(endDate.add(Duration(days: 1)));
    }));

    selectedDayItems.sort((a, b) {
      final DateTime startTimeA = a is Journey
          ? a.journeyStartTime
          : a is Event
              ? a.eventStartTime
              : DateTime.now(); // 默认值，但在你的应用中，你可能永远不会遇到这种情况

      final DateTime startTimeB = b is Journey
          ? b.journeyStartTime
          : b is Event
              ? b.eventStartTime
              : DateTime.now(); // 默认值

      return startTimeA.compareTo(startTimeB);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JourneyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Utils.day(provider.selectedDate),
          style: TextStyle(color: Colors.black, fontSize: 20), // 修改字体大小为20
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4A7DAB),
        leading: CloseButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/MyBottomBar2',
              ModalRoute.withName('/'),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JourneyEditingPage(
                    addTodayDate: true,
                    time: DateTime(
                      provider.selectedDate.year,
                      provider.selectedDate.month,
                      provider.selectedDate.day,
                      DateTime.now().hour,
                      DateTime.now().minute,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: selectedDayItems.length,
                itemBuilder: (context, index) {
                  final item = selectedDayItems[index];
                  if (item is Journey) {
                    final journey = item;
                    return buildJourneyTile(journey);
                  } else if (item is Event) {
                    final event = item;
                    return buildEventTile(event);
                  } else {
                    return SizedBox(); // Placeholder for other types if needed
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJourneyTile(Journey journey) {
    return ListTile(
      title: Text(
        journey.journeyName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            '起始時間：${Utils.toDateTime(journey.journeyStartTime)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '結束時間：${Utils.toDateTime(journey.journeyEndTime)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JourneyViewingPage(journey: journey),
          ),
        );
      },
    );
  }

  Widget buildEventTile(Event event) {
    return ListTile(
      title: Text(
        event.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            '起始時間：${Utils.toDateTime(event.eventStartTime)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '截止時間：${Utils.toDateTime(event.deadline)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventViewingPage(event: event),
          ),
        );
      },
    );
  }
}
