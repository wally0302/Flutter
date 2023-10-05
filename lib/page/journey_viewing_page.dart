// 行程詳細資料頁面
// ignore_for_file: prefer_const_constructors, unused_import, duplicate_ignore

import 'package:create_event2/page/journey_editing_page.dart';
import 'package:create_event2/provider/journey_provider.dart';
// ignore: unused_import
import 'package:create_event2/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/model/journey.dart';
import 'package:get/get.dart';

class JourneyViewingPage extends StatelessWidget {
  final Journey journey;

  const JourneyViewingPage({
    Key? key,
    required this.journey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //左邊的 X
        leading: CloseButton(
          onPressed: () {
            Navigator.pop(context, journey); // 關閉此頁面 返回上一頁
          },
        ),
        //右邊的 編輯 和 刪除
        actions: buildViewingActions(context, journey),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          Text(
            journey.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          buildDateTime(journey), //時間
          const SizedBox(
            height: 24,
          ),
          buildLocation(journey), //地點
          const SizedBox(
            height: 24,
          ),
          buildRemark(journey), //備註
          const SizedBox(
            height: 24,
          ),
          buildNotification(journey, journey.notification) //提醒
        ],
      ),
    );
  }

// 時間
  Widget buildDateTime(Journey journey) {
    return Column(
      children: [
        //整天 or 非整天
        buildDate(journey.isAllDay ? '全天起始日期：' : '起始時間：', journey.from),
        buildDate(journey.isAllDay ? '全天結束日期：' : '結束時間：', journey.to),
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
          !journey.isAllDay ? dateString1 : dateString2,
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
    if (journey.enableNotification) {
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
          Text(notification != 0 ? '$notification 分鐘' : '時間到提醒',
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
    final journeyProvider =
        Provider.of<JourneyProvider>(context, listen: false);

    return [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => JourneyEditingPage(
                journey: journey,
                addTodayDate: true,
                time: journey.from,
              ),
            ),
          );
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('確認刪除'),
              content: Text('確定要刪除這個行程嗎？'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    journeyProvider.deleteJourney(journey);
                    //回到主畫面
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/MyBottomBar2',
                      ModalRoute.withName('/'),
                    );
                  },
                  child: Text('確定'),
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  // List<Widget> buildViewingActions(BuildContext context, Journey journey) => [
  //       //編輯按鈕
  //       IconButton(
  //           icon: Icon(Icons.edit),
  //           onPressed: () {
  //             //pushReplacement 方法中，會將當前頁面替換成新的頁面，而不是在當前頁面上疊加新的頁面。
  //             //它會回到 "主畫面"
  //             Navigator.of(context).pushReplacement(
  //               MaterialPageRoute(
  //                 // 將使用者導向到 JourneyEditingPage 頁面，並將當前的 journey 物件傳遞給該頁面
  //                 builder: (context) => JourneyEditingPage(
  //                   journey: journey,
  //                   addTodayDate: true,
  //                   time: journey.from,
  //                 ),
  //               ),
  //             );
  //           }),
  //       //刪除按鈕
  //       IconButton(
  //         icon: Icon(Icons.delete),
  //         onPressed: () {
  //           Get.defaultDialog(
  //             title: "提示",
  //             titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             middleText: "是否刪除此行程?",
  //             middleTextStyle: TextStyle(fontSize: 18),
  //             backgroundColor: Colors.pinkAccent,
  //             radius: 30,
  //             textCancel: "取消",
  //             cancelTextColor: Colors.white,
  //             textConfirm: "確認",
  //             confirmTextColor: Colors.white,
  //             buttonColor: Colors.blueGrey,
  //             onCancel: () {
  //               Navigator.of(context).pop(); //關閉對話框，返回上一頁
  //             },
  //             onConfirm: () {
  //               final provider =
  //                   Provider.of<JourneyProvider>(context, listen: false);
  //               provider.deleteJourney(journey);
  //               //回到主畫面
  //               Navigator.pushNamedAndRemoveUntil(
  //                 context,
  //                 '/MyBottomBar2',
  //                 ModalRoute.withName('/'),
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     ];
}
