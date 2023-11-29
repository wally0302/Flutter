// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages
import 'package:create_event2/model/journey.dart';
import 'package:create_event2/model/journey_data_source.dart';
import 'package:create_event2/page/selectday_viewing_page.dart';
import 'package:create_event2/provider/journey_provider.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/event.dart';
import '../model/event_data_source.dart';
import '../services/http.dart';
import '../services/sqlite.dart';
// import 'drawer_page.dart';
import 'login_page.dart';

// 主頁面
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 顯示行事曆方式controller
  final CalendarController _controller = CalendarController();
  List<Journey> journeylist = [];
  List<Event> eventlist = [];

  @override
  void initState() {
    super.initState();
    Sqlite.dropDatabase(); // 清空 sqlite 資料庫
    getCalendarDateJourney();
    getCalendarDateEvent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final journeys = Provider.of<JourneyProvider>(context).journeys;
    // final events = Provider.of<EventProvider>(context).events;

    final List<Appointment> appointments = [];

    for (final journey in journeylist) {
      appointments.add(Appointment(
        startTime: journey.journeyStartTime,
        endTime: journey.journeyEndTime,
        subject: journey.journeyName,
        color: journey.color,
      ));
    }

    for (final event in eventlist) {
      appointments.add(Appointment(
        startTime: event.eventFinalStartTime,
        endTime: event.eventFinalEndTime,
        subject: event.eventName,
      ));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // endDrawer: Drawer_Page(), //右側滑出選單
        appBar: AppBar(
          title: const Text('行事曆', style: TextStyle(color: Colors.black)),
          centerTitle: true, //標題置中
          backgroundColor: Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        ),
        body: SfCalendar(
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
          ],
          controller: _controller,
          showDatePickerButton: true, //顯示日期選擇按鈕
          headerStyle: CalendarHeaderStyle(
              textStyle: TextStyle(fontSize: 25)), //左上角顯示日期的字體大小
          view: CalendarView.month, //預設顯示月曆
          dataSource: _DataSource(appointments), // 裝行事曆的資料
          // dataSource: JourneyDateSource(journeylist), // 顯示journeytest的資料
          cellEndPadding: 5, //
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode:
                  MonthAppointmentDisplayMode.appointment), //顯示行事曆方式
          initialSelectedDate: DateTime.now(), // 預設選擇日期
          cellBorderColor: Colors.transparent,
          //當使用者點擊行事曆中的某一天時，會將該日期設定為 JourneyProvider 中的選擇日期，
          //然後導航到 SelectedDayViewingPage 頁面
          onTap: (details) {
            final provider =
                Provider.of<JourneyProvider>(context, listen: false);
            provider.setDate(details.date!);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SelectedDayViewingPage()),
            );
            // showModalBottomSheet(
            //     context: context, builder: (context) => const TaskWidget());
          },
        ),
      ),
    );
  }

  getCalendarDateJourney() async {
    // 從server抓使用者行事曆資料

    var userMall = {'userMall': FirebaseEmail}; //到時候要改成登入的使用者

    final result = await APIservice.selectJourneyAll(
        content: userMall,
        userMall: FirebaseEmail!); // 從 server 抓使用者行事曆資料，就會把資料存入 sqlite
    // print(
    //     '------------------------------------------------------------------------------');
    // print("該 $FirebaseEmail 的資料: $result"); //，是一個陣列 [{}, {}, {}]

    // print(
    //     '------------------------------------------------------------------------------');
    // print(result[0]); // 是一個 {}，裡面有很多個 key:value ，{jID: 42, uID: 12345, journeyName: wally, journeyStartTime: 202308141556, journeyEndTime: 202308141756, isAllDay: 0, location: qqq, remindStatus: 1, remindTime: 0, remark: qqq, color: 4278190080}
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable =
        await Sqlite.queryAll(tableName: 'journey'); // 從 sqlite 拿資料
    queryCalendarTable ??= []; // 如果沒有資料，就給一個空陣列
    setState(() {
      journeylist = queryCalendarTable!
          .map((e) => Journey.fromMap(e))
          .toList(); //將 queryCalendarTable 轉換成 Event 物件的 List，讓 SfCalendar 可以顯示
    });
    // for (var element in queryCalendarTable) {
    //   print('-----element-----');
    //   print(element);
    // }
    // --------------------------------------

    // print('-----evenTest-----');
    // print(journeylist); // 是一個 List<Event>，裡面有很多個 Event 物件
    // for (var event in journeylist) {
    //   print('-----event-----');
    //   print(event.journeyName); // 印出 Event 物件的 journeyName
    // }

    return queryCalendarTable;
  }

  getCalendarDateEvent() async {
    // 從server抓使用者行事曆資料
    var userMall = {'userMall': FirebaseEmail}; //到時候要改成登入的使用者
    final resulthome = await APIservice.selectHomeEventAll(
        content: userMall,
        userMall: FirebaseEmail!); // 從 server 抓使用者行事曆資料，就會把資料存入 sqlite
    dynamic resultguestData = await APIservice.selectGuestEventAll(
        content: userMall, guestMall: FirebaseEmail!);

    print(
        '------------------------------------------------------------------------------');
    print("該 $userMall 的資料: $resulthome"); //，是一個陣列 [{}, {}, {}]
    print(
        '------------------------------------------------------------------------------');
    // print(result[
    //     0]); // 是一個 {}，裡面有很多個 key:value ，{jID: 42, uID: 12345, journeyName: wally, journeyStartTime: 202308141556, journeyEndTime: 202308141756, isAllDay: 0, location: qqq, remindStatus: 1, remindTime: 0, remark: qqq, color: 4278190080}
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable =
        await Sqlite.queryAll(tableName: 'event'); // 從 sqlite 拿資料
    queryCalendarTable ??= []; // 如果沒有資料，就給一個空陣列
    setState(() {
      eventlist = queryCalendarTable!
          .map((e) => Event.fromMap(e))
          .toList(); //將 queryCalendarTable 轉換成 Event 物件的 List，讓 SfCalendar 可以顯示
    });

    return queryCalendarTable;
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
