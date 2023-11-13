// 行程詳細資料頁面
// ignore_for_file: prefer_const_constructors, unused_import, duplicate_ignore

import 'package:create_event2/page/journey/journey_editing_page.dart';
import 'package:create_event2/provider/journey_provider.dart';
// ignore: unused_import
import 'package:create_event2/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/model/journey.dart';
import 'package:get/get.dart';

import '../../services/http.dart';
import '../../services/sqlite.dart';

class JourneyViewingPage extends StatefulWidget {
  final Journey journey;

  const JourneyViewingPage({
    Key? key,
    required this.journey,
  }) : super(key: key);

  @override
  _JourneyViewingPageState createState() => _JourneyViewingPageState();
}

class _JourneyViewingPageState extends State<JourneyViewingPage> {
  late Journey _currentJourney;

  @override
  void initState() {
    super.initState();
    _currentJourney = widget.journey;
  }

  getCalendarDate() async {
    //await Sqlite.dropDatabase();
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable = await Sqlite.queryAll(tableName: 'journey');
    queryCalendarTable ??= [];
    for (var element in queryCalendarTable) {
      print(element);
    }
    return queryCalendarTable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pop(_currentJourney);
          },
        ),
        actions: buildViewingActions(context, _currentJourney),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          Text(
            _currentJourney.journeyName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          buildDateTime(_currentJourney),
          const SizedBox(
            height: 24,
          ),
          buildLocation(_currentJourney),
          const SizedBox(
            height: 24,
          ),
          buildRemark(_currentJourney),
          const SizedBox(
            height: 24,
          ),
          buildNotification(_currentJourney, _currentJourney.remindTime)
        ],
      ),
    );
  }

// 時間
  Widget buildDateTime(Journey journey) {
    return Column(
      children: [
        //整天 or 非整天
        buildDate(
            journey.isAllDay ? '全天起始日期：' : '起始時1間：', journey.journeyStartTime),
        buildDate(
            journey.isAllDay ? '全天結束日期：' : '結束時間：', journey.journeyEndTime),
      ],
    );
  }

//根據是否是全天事件來顯示不同的日期格式
  Widget buildDate(String date, DateTime dateTime) {
    final dateFormatter1 = DateFormat('E, d MMM yyyy HH:mm');
    final dateFormatter2 = DateFormat('E, d MMM yyyy');
    final dateString1 = dateFormatter1.format(dateTime);
    final dateString2 = dateFormatter2.format(dateTime);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            date,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          !_currentJourney.isAllDay ? dateString1 : dateString2,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

// 地點
  Widget buildLocation(Journey journey) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined),
        const SizedBox(
          width: 3,
        ),
        Text(
          '地點：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(journey.location.isNotEmpty ? journey.location : '無',
            style: TextStyle(fontSize: 18))
      ],
    );
  }

//備註
  Widget buildRemark(Journey journey) {
    return Row(
      children: [
        Icon(Icons.article_outlined),
        const SizedBox(
          width: 3,
        ),
        Text(
          '備註：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(journey.remark.isNotEmpty ? journey.remark : '無',
            style: TextStyle(fontSize: 18))
      ],
    );
  }

  Widget buildNotification(Journey journey, int notification) {
    if (journey.remindStatus) {
      return Row(
        children: [
          Icon(Icons.alarm),
          const SizedBox(
            width: 3,
          ),
          Text(
            '提醒：',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(notification != 0 ? '$notification 分鐘' : '1時間到提醒',
              style: TextStyle(fontSize: 18))
        ],
      );
    } else {
      return Row(
        children: const [
          Icon(Icons.notifications_off),
          SizedBox(width: 3),
          Text(
            '提醒：',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '無通知',
            style: TextStyle(fontSize: 18),
          ),
        ],
      );
    }
  }

  List<Widget> buildViewingActions(BuildContext context, Journey journey) {
    return [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          final editedJourney = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JourneyEditingPage(
                journey: _currentJourney,
                addTodayDate: true,
                time: _currentJourney.journeyEndTime,
              ),
            ),
          );

          if (editedJourney != null) {
            setState(() {
              _currentJourney = editedJourney;
            });
          }
          print('顯示事件:');
          print(_currentJourney.journeyName);
          getCalendarDate();
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          Get.defaultDialog(
            title: "提示",
            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            middleText: "是否刪除此行程?",
            middleTextStyle: TextStyle(fontSize: 18),
            backgroundColor: Colors.pinkAccent,
            radius: 30,
            textCancel: "取消",
            cancelTextColor: Colors.white,
            textConfirm: "確認",
            confirmTextColor: Colors.white,
            buttonColor: Colors.blueGrey,
            onCancel: () {
              Navigator.of(context).pop();
            },
            onConfirm: () async {
              final List result = await APIservice.deleteJourney(
                  content: _currentJourney.toMap(), jID: _currentJourney.jID!);
              print(result[0]);
              if (result[0]) {
                var result = await Sqlite.deleteJourney(
                  tableName: 'journey',
                  tableIdName: 'jid',
                  deleteId: _currentJourney.jID ?? 0,
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/MyBottomBar2',
                  ModalRoute.withName('/'),
                );
              } else {
                print('在server刪除行程失敗');
              }
            },
          );
        },
      ),
    ];
  }
}
