import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';

import '../model/friend.dart';

class Event {
  final int? eID;
  final String? uID;
  final String eventName; //名稱
  final DateTime eventBlockStartTime; //匹配起始日
  final DateTime eventBlockEndTime; //匹配結束日
  final DateTime eventTime; //活動預計開始時間
  final int timeLengtHours; //活動預計長度
  final int timeLengthMins;
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
    this.uID,
    required this.eventName,
    required this.eventBlockStartTime,
    required this.eventBlockEndTime,
    required this.eventTime,
    required this.timeLengtHours,
    required this.timeLengthMins,
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

  Map<String, dynamic> toMap() {
    return {
      'uID': uID,
      'eventName': eventName,
      'eventBlockStartTime': eventBlockStartTime.millisecondsSinceEpoch,
      'eventBlockEndTime': eventBlockEndTime.millisecondsSinceEpoch,
      'eventTime': eventTime,
      'timeLengtHours': timeLengtHours,
      'timeLengthMins': timeLengthMins,
      'eventFinalStartTime': eventFinalStartTime.millisecondsSinceEpoch,
      'eventFinalEndTime': eventFinalEndTime.millisecondsSinceEpoch,
      'state': state,
      'matchTime': matchTime.millisecondsSinceEpoch,
      'location': location,
      'remindStatus': remindStatus,
      'remindTime': remindTime.millisecondsSinceEpoch,
      'remark': remark,
      // 'friends': friends
      //     .map((friend) => friend.toMap())
      //     .toList(), // 假定 Friend 類別也有 toMap() 方法
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    print('-----map-----');
    print(map['uID']);
    return Event(
      eID: int.parse(map['eID'].toString()),
      uID: map['uID'].toString(),
      eventName: map['eventName'],
      eventBlockStartTime:
          DateTime.parse(map['eventBlockStartTime'].toString()),
      eventBlockEndTime: DateTime.parse(map['eventBlockEndTime'].toString()),
      eventTime: DateTime.parse(map['eventTime'].toString()),
      timeLengtHours: int.parse(map['timeLengthHours'].toString()),
      timeLengthMins: int.parse(map['timeLengthMins'].toString()),
      eventFinalStartTime:
          DateTime.parse(map['eventFinalStartTime'].toString()),
      eventFinalEndTime: DateTime.parse(map['eventFinalEndTime'].toString()),
      state: int.parse(map['state'].toString()),
      matchTime: DateTime.parse(map['matchTime'].toString()),
      location: map['location'],
      remindStatus: map['remindStatus'] == 1,
      remindTime: DateTime.parse(map['remindTime'].toString()),
      remark: map['remark'],
      friends: [],
    );
  }
}
