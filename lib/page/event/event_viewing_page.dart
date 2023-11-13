// 活動詳細資料頁面
// ignore_for_file: prefer_const_constructors, unused_import, duplicate_ignore

import 'package:create_event2/page/event/event_editing_page.dart';
import 'package:create_event2/provider/event_provider.dart';
// ignore: unused_import
import 'package:create_event2/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/model/event.dart';
import 'package:get/get.dart';

import '../../model/friend.dart';
import '../../services/http.dart';
import '../login_page.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;
  final bool isMatched = true; // 是否匹配 (這裡會接收後端確認是否有媒合成功)
  final bool show; // 新增参数来控制是否显示时间

  const EventViewingPage({
    Key? key,
    required this.event,
    this.show = true, // 默认为 true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMatched
        ? _buildMatchedPage(context)
        : _buildNotMatchedPage(context);
  }

//媒合成功
  Widget _buildMatchedPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4A7DAB), // 设置 AppBar 的颜色
        leading: CloseButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, event);
          },
        ),
        actions: buildViewingActions(context, event), //编辑和删除按钮
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            padding: EdgeInsets.all(32),
            children: <Widget>[
              Text(
                event.eventName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              buildConfirmationTime(event), //匹配的正确活动时间
              const SizedBox(
                height: 24,
              ),
              buildLocation(event), //地点
              const SizedBox(
                height: 24,
              ),
              buildRemark(event), //备注
              const SizedBox(
                height: 24,
              ),
              buildInvitedFriendsList(event.friends), //参加的好友
              const SizedBox(
                height: 24,
              ),
              buildDeadline(event.matchTime), //媒合開始時間
              buildNotification(event, event.remindStatus) //提醒
            ],
          ),
        ],
      ),
    );
  }

//媒合失敗
  Widget _buildNotMatchedPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4A7DAB), // 设置 AppBar 的颜色
        leading: CloseButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, event); // 关闭此页面 返回上一页
          },
        ),
        actions: buildViewingActions(context, event), //编辑和删除按钮
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            padding: EdgeInsets.all(32),
            children: <Widget>[
              Text(
                event.eventName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              buildDateTime(event), //时间
              const SizedBox(
                height: 24,
              ),
              buildBeginDate(event), //活动预计开始时间
              const SizedBox(
                height: 24,
              ),
              buildDurationLength(event),
              const SizedBox(
                height: 24,
              ),
              buildLocation(event), //地点
              const SizedBox(
                height: 24,
              ),
              buildRemark(event), //备注
              const SizedBox(
                height: 24,
              ),
              buildInvitedFriendsList(event.friends), //邀请好友
              const SizedBox(
                height: 24,
              ),
              buildDeadline(event.matchTime), //媒合開始時間
              const SizedBox(
                height: 24,
              ),
              const SizedBox(
                height: 24,
              ),
              buildNotification(event, event.remindStatus) //提醒
            ],
          ),
        ],
      ),
    );
  }

  // 截止時間
  Widget buildDeadline(DateTime deadline) {
    if (show) {
      return SizedBox.shrink(); // 如果 show 為 true，則返回一個空的 SizedBox
    }

    final dateFormatter = DateFormat('E, d MMM yyyy HH:mm');
    final dateString = dateFormatter.format(deadline);

    return Row(
      children: [
        Icon(Icons.timer),
        const SizedBox(
          width: 3,
        ),
        Text(
          '媒合開始時間：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(dateString, style: TextStyle(fontSize: 18)),
      ],
    );
  }

  //邀請好友
  Widget buildInvitedFriendsList(List<Friend> invitedFriends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '參加的好友：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: invitedFriends.map((friend) {
            return Text(
              friend.name,
              style: TextStyle(fontSize: 18),
            );
          }).toList(),
        ),
      ],
    );
  }

// 從後端媒合的正確時間
  Widget buildConfirmationTime(Event event) {
    if (!show) {
      return SizedBox.shrink(); // 如果 show 為 false，則返回一個空的 SizedBox
    }

    return Column(
      children: [
        buildConfirmationDate(
            '起始時間：', event.eventBlockStartTime), // 要替換為後端的媒合時間
        buildConfirmationDate('結束時間：', event.eventBlockEndTime),
      ],
    );
  }

  Widget buildConfirmationDate(String date, DateTime dateTime) {
    final dateFormatter2 = DateFormat('E, d MMM yyyy HH:mm');
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
          dateString2,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

// 匹配的活動時間
  Widget buildDateTime(Event event) {
    return Column(
      children: [
        //整天 or 非整天
        buildDate('匹配起始日：', event.eventBlockStartTime),
        buildDate('匹配結束日：', event.eventBlockEndTime),
      ],
    );
  }

  Widget buildDate(String date, DateTime dateTime) {
    final dateFormatter2 = DateFormat('E, d MMM yyyy');
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
          dateString2,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

//活動預計開始時間
  Widget buildBeginDate(Event event) {
    final timeFormatter = DateFormat('HH:mm');
    final timeString = timeFormatter.format(event.eventTime);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '活動預計開始時間：',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          timeString,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget buildDurationLength(Event event) {
    final startHour = event.timeLengthHours;
    // final startMinute = event.timeLengthMins;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '活動預計時間長度：',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Text(
        //   '$startHour 小時 $startMinute 分鐘',
        //   style: TextStyle(fontSize: 18),
        // )
      ],
    );
  }

// 地點
  Widget buildLocation(Event event) {
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
        Text(event.location.isNotEmpty ? event.location : '無',
            style: TextStyle(fontSize: 18))
      ],
    );
  }

//備註
  Widget buildRemark(Event event) {
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
        Text(event.remark.isNotEmpty ? event.remark : '無',
            style: TextStyle(fontSize: 18))
      ],
    );
  }

  Widget buildNotification(Event event, bool notification) {
    if (event.remindStatus) {
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
          Text(notification != true ? '$notification 分鐘' : '時間到提醒',
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

  List<Widget> buildViewingActions(BuildContext context, Event event) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return [
      IconButton(
        icon: Icon(Icons.edit, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(
                event: event,
                addTodayDate: true,
                time: event.eventBlockStartTime,
              ),
            ),
          );
        },
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Colors.black),
        onPressed: () async {
          // 显示确认删除的对话框
          final confirmDelete = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('確認删除'),
              content: Text('确定要刪除這個活動嗎？'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('確定'),
                ),
              ],
            ),
          );

          if (confirmDelete == true) {
            await APIservice.deleteEvent(
                content: {'userMall': FirebaseEmail},
                eID: event.eID.toString());

            eventProvider.deleteEvent(event);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('活動已刪除'),
              ),
            );

            // 返回到活动列表页面
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/MyBottomBar2',
              ModalRoute.withName('/'),
            );
          }
        },
      ),
    ];
  }
}
