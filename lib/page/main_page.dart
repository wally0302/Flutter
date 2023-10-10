// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages
import 'package:create_event2/page/selectday_viewing_page.dart';
import 'package:create_event2/provider/journey_provider.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'drawer_page.dart';

// 主頁面
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 顯示行事曆方式controller
  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journeys = Provider.of<JourneyProvider>(context).journeys;
    final events = Provider.of<EventProvider>(context).events;

    final List<Appointment> appointments = [];
    for (final journey in journeys) {
      appointments.add(Appointment(
        startTime: journey.journeyStartTime,
        endTime: journey.journeyEndTime,
        subject: journey.journeyName,
        color: journey.color,
      ));
    }
    for (final event in events) {
      appointments.add(Appointment(
        startTime: event.eventStartTime,
        endTime: event.eventEndTime,
        subject: event.title,
        color: event.backgroundColor,
      ));
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        endDrawer: Drawer_Page(), //右側滑出選單
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
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
