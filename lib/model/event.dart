import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';

import '../model/friend.dart';

class Event {
  final int? eID;
  final String? userMall;
  final String eventName; //名稱
  final DateTime eventBlockStartTime; //匹配起始日
  final DateTime eventBlockEndTime; //匹配結束日
  final DateTime eventTime; //活動預計開始時間
  final int timeLengthHours; //活動預計長度
  // final int timeLengthMins;
  final String location; //地點
  final String remark; //備註
  final List<Friend> friends; //參加好友
  final DateTime matchTime; //媒合開始時間
  final bool remindStatus; //提醒是否開 1:開啟 0:關閉
  final DateTime remindTime; //提醒時間
  //-------------------------------------------
  //後端會回傳給前端的資料
  final int state; //1:已完成媒合 0:未完成媒合
  final DateTime eventFinalStartTime; //最終確定時間 年月日時分
  final DateTime eventFinalEndTime;

  const Event({
    this.eID,
    this.userMall,
    required this.eventName,
    required this.eventBlockStartTime,
    required this.eventBlockEndTime,
    required this.eventTime,
    required this.timeLengthHours,
    // required this.timeLengthMins,
    required this.eventFinalStartTime,
    required this.eventFinalEndTime,
    this.state = 0,
    required this.matchTime,
    this.location = '',
    this.remindStatus = false,
    required this.remindTime,
    this.remark = '',
    required this.friends,
  });

  get start => null;

  get date => null;

  //轉換成 json 格式，存進 sqlite
  Map<String, dynamic> toMap() {
    return {
      'eID': eID,
      'userMall': userMall,
      'eventName': eventName,
      // 將 DateTime 轉換為自定義的整數格式
      'eventBlockStartTime': eventBlockStartTime.year * 100000000 +
          eventBlockStartTime.month * 1000000 +
          eventBlockStartTime.day * 10000 +
          eventBlockStartTime.hour * 100 +
          eventBlockStartTime.minute,
      'eventBlockEndTime': eventBlockEndTime.year * 100000000 +
          eventBlockEndTime.month * 1000000 +
          eventBlockEndTime.day * 10000 +
          eventBlockEndTime.hour * 100 +
          eventBlockEndTime.minute,
      // 活動預計開始時間，如果是 DateTime，也需要轉換
      'eventTime': eventTime.year * 100000000 +
          eventTime.month * 1000000 +
          eventTime.day * 10000 +
          eventTime.hour * 100 +
          eventTime.minute,
      'timeLengthHours': timeLengthHours,
      'location': location,
      'remark': remark,
      // 將 List<Friend> 轉換為逗號分隔的字符串
      'friends': friends.map((e) => e.name).join(','),
      // 同樣將 DateTime 轉換為自定義的整數格式
      'matchTime': matchTime.year * 100000000 +
          matchTime.month * 1000000 +
          matchTime.day * 10000 +
          matchTime.hour * 100 +
          matchTime.minute,
      // 將 bool 轉換為整數
      'remindStatus': remindStatus ? 1 : 0,
      // 提醒時間，如果是 DateTime，也需要轉換
      'remindTime': remindTime.year * 100000000 +
          remindTime.month * 1000000 +
          remindTime.day * 10000 +
          remindTime.hour * 100 +
          remindTime.minute,
      'state': state,
      // 最終確定時間，也需要轉換
      'eventFinalStartTime': eventFinalStartTime.year * 100000000 +
          eventFinalStartTime.month * 1000000 +
          eventFinalStartTime.day * 10000 +
          eventFinalStartTime.hour * 100 +
          eventFinalStartTime.minute,
      'eventFinalEndTime': eventFinalEndTime.year * 100000000 +
          eventFinalEndTime.month * 1000000 +
          eventFinalEndTime.day * 10000 +
          eventFinalEndTime.hour * 100 +
          eventFinalEndTime.minute,
    };
  }

  factory Event.fromMap(Map<String, dynamic> event) {
    int eventBlockStartTimeInt = event['eventBlockStartTime'];
    int eventBlockEndTimeInt = event['eventBlockEndTime'];
    int eventFinalStartTimeInt = event['eventFinalStartTime'];
    int eventFinalEndTimeInt = event['eventFinalEndTime'];
    int matchTimeInt = event['matchTime'];
    int eventTimeInt = event['eventTime'];
    int timeLengthHoursInt = event['timeLengthHours'];
    // int timeLengthMinsInt = event['timeLengthMins'];
    String friendsString = event['friends']; //wally,jack
    List<String> friendsList = friendsString.split(','); //["wally", "jack"]
    List<Friend> friendObjects =
        friendsList.map((name) => Friend.fromName(name)).toList();
    int remindTimeInt = event['remindTime'];

    DateTime eventBlockStartTime = DateTime(
        eventBlockStartTimeInt ~/ 100000000, // 年
        (eventBlockStartTimeInt % 100000000) ~/ 1000000, // 月
        (eventBlockStartTimeInt % 1000000) ~/ 10000, // 日
        (eventBlockStartTimeInt % 10000) ~/ 100, // 小时
        eventBlockStartTimeInt % 100 // 分钟
        );
    DateTime eventBlockEndTime = DateTime(
        eventBlockEndTimeInt ~/ 100000000, // 年
        (eventBlockEndTimeInt % 100000000) ~/ 1000000, // 月
        (eventBlockEndTimeInt % 1000000) ~/ 10000, // 日
        (eventBlockEndTimeInt % 10000) ~/ 100, // 小时
        eventBlockEndTimeInt % 100 // 分钟
        );
    DateTime eventTime = DateTime(
        eventTimeInt ~/ 100000000, // 年
        (eventTimeInt % 100000000) ~/ 1000000, // 月
        (eventTimeInt % 1000000) ~/ 10000, // 日
        (eventTimeInt % 10000) ~/ 100, // 小时
        eventTimeInt % 100 // 分钟
        );
    DateTime matchTime = DateTime(
        matchTimeInt ~/ 100000000, // 年
        (matchTimeInt % 100000000) ~/ 1000000, // 月
        (matchTimeInt % 1000000) ~/ 10000, // 日
        (matchTimeInt % 10000) ~/ 100, // 小时
        matchTimeInt % 100 // 分钟
        );
    DateTime remindTime = DateTime(
        remindTimeInt ~/ 100000000, // 年
        (remindTimeInt % 100000000) ~/ 1000000, // 月
        (remindTimeInt % 1000000) ~/ 10000, // 日
        (remindTimeInt % 10000) ~/ 100, // 小时
        remindTimeInt % 100 // 分钟
        );
    DateTime eventFinalStartTime = DateTime(
        eventFinalStartTimeInt ~/ 100000000, // 年
        (eventFinalStartTimeInt % 100000000) ~/ 1000000, // 月
        (eventFinalStartTimeInt % 1000000) ~/ 10000, // 日
        (eventFinalStartTimeInt % 10000) ~/ 100, // 小时
        eventFinalStartTimeInt % 100 // 分钟
        );
    DateTime eventFinalEndTime = DateTime(
        eventFinalEndTimeInt ~/ 100000000, // 年
        (eventFinalEndTimeInt % 100000000) ~/ 1000000, // 月
        (eventFinalEndTimeInt % 1000000) ~/ 10000, // 日
        (eventFinalEndTimeInt % 10000) ~/ 100, // 小时
        eventFinalEndTimeInt % 100 // 分钟
        );
    return Event(
      eID: event['eID'],
      userMall: event['userMall'],
      eventName: event['eventName'],
      // 匹配起始日
      eventBlockStartTime: eventBlockStartTime,

      // 匹配結束日
      eventBlockEndTime: eventBlockEndTime,
      //活動預計開始時間
      eventTime: eventTime,
      //活動預計時間長度
      timeLengthHours: timeLengthHoursInt,
      // timeLengthMins: timeLengthMinsInt,
      //地點
      location: event['location'],
      //備註
      remark: event['remark'],
      //參加好友
      friends: friendObjects,
      //媒合開始時間
      matchTime: matchTime,
      //提醒是否開 1:開啟 0:關閉
      remindStatus: event['remindStatus'] == 1,
      //提醒時間
      remindTime: remindTime,
      //-------------------------------------------
      //後端會回傳給前端的資料
      //1:已完成媒合 0:未完成媒合
      state: event['state'],
      //最終確定時間 年月日時分
      eventFinalStartTime: eventFinalStartTime,
      eventFinalEndTime: eventFinalEndTime,
    );
  }
}
