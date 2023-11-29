// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, avoid_print

import 'package:create_event2/page/journey/journey_editing_page.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:create_event2/utils.dart';
import 'package:create_event2/model/event.dart';
import 'package:create_event2/page/journey/journey_viewing_page.dart';
import 'package:create_event2/services/sqlite.dart';

import '../model/journey.dart';
import '../provider/journey_provider.dart';

class SelectedDayViewingPage extends StatefulWidget {
  const SelectedDayViewingPage({
    super.key,
  });

  @override
  State<SelectedDayViewingPage> createState() => _SelectedDayViewingPageState();
}

class _SelectedDayViewingPageState extends State<SelectedDayViewingPage> {
  List<Journey> selectedDayJourney = []; // 存選擇當天行程的資料
  List<Journey> journeylist = [];
  List<Event> selectedDayEvent = []; // 存選擇當天行程的資料
  List<Event> eventlist = [];

  @override
  void initState() {
    final provider = Provider.of<JourneyProvider>(context, listen: false);
    provider.fetchJourneysFromDatabase(); //抓資料庫資料
    selectedDayJourney.clear(); //清空當天行程資料
    fetchSelectedDayJourney(); //抓當天行程資料
    final providerevent = Provider.of<EventProvider>(context, listen: false);
    providerevent.fetchEventsFromDatabase();
    selectedDayEvent.clear();
    fetchSelectedDayEvent();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchSelectedDayJourney() async {
    final provider = Provider.of<JourneyProvider>(context, listen: false);
    final selectedDate = provider.selectedDate;

    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable =
        await Sqlite.queryAll(tableName: 'journey'); //拿所有 journey 資料
    queryCalendarTable ??= [];

    setState(() {
      journeylist = queryCalendarTable!.map((e) => Journey.fromMap(e)).toList();
    });
    setState(() {
      // 抓當天 journey 資料
      selectedDayJourney = journeylist.where((journey) {
        // 判斷行程是否在時間內
        final startDateTime = journey.journeyStartTime;
        final endDateTime = journey.journeyEndTime;

        final startDate = DateTime(
            startDateTime.year, startDateTime.month, startDateTime.day);
        final endDate =
            DateTime(endDateTime.year, endDateTime.month, endDateTime.day);
        // 起始時間-1,結束時間+1的區間來判斷
        return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            selectedDate.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    });
  }

  void fetchSelectedDayEvent() async {
    final provider = Provider.of<JourneyProvider>(context, listen: false);
    final selectedDate = provider.selectedDate;
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable = await Sqlite.queryAll(tableName: 'event');
    queryCalendarTable ??= [];
    //timeLengthMins
    setState(() {
      eventlist = queryCalendarTable!.map((e) => Event.fromMap(e)).toList();
    });

    setState(() {
      selectedDayEvent = eventlist.where((event) {
        // 判斷行程是否在時間內
        final startDateTime = event.eventFinalStartTime;
        final endDateTime = event.eventFinalEndTime;

        final startDate = DateTime(
            startDateTime.year, startDateTime.month, startDateTime.day);
        final endDate =
            DateTime(endDateTime.year, endDateTime.month, endDateTime.day);
        // 起始時間-1,結束時間+1的區間來判斷
        return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            selectedDate.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JourneyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.day(provider.selectedDate),
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF4A7DAB),
        leading: CloseButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/MyBottomBar2', ModalRoute.withName('/'));
          },
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
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
                        DateTime.now().minute),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildJourneyListView(),
                        _buildEventListView(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: selectedDayJourney.length,
      itemBuilder: (context, index) {
        final journey = selectedDayJourney[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => JourneyViewingPage(
                        journey: journey,
                      )),
            );
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: journey.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 47,
                width: 5,
              ),
              Expanded(
                child: ListTile(
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
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: selectedDayEvent.length,
      itemBuilder: (context, index) {
        final event = selectedDayEvent[index];
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 47,
              width: 5,
            ),
            Expanded(
              child: ListTile(
                  title: Text(
                    event.eventName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        '起始時間：${Utils.toDateTime(event.eventFinalStartTime)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '結束時間：${Utils.toDateTime(event.eventFinalEndTime)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }
}
