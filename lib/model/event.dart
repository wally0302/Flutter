import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';

import '../model/friend.dart';

class Event {
  final int? eID;
  final String? uID;
  final String eventName;
  final DateTime eventBlockStartTime;
  final DateTime eventBlockEndTime;
  final DateTime eventTime; //活動預計開始時間
  final int timeLengtHours;
  final int timeLengthMins;
  final DateTime eventFinalStartTime; //最終確定時間 年月日時分
  final DateTime eventFinalEndTime;
  final int state; //1:已完成媒合 0:未完成媒合
  final DateTime matchTime; //媒合開始時間
  final List<Friend> friends;
  final String location;
  final int remindStatus; //提醒是否開 1:開啟 0:關閉
  final DateTime remindTime;
  final String remark; //備註

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
    this.remindStatus = 0,
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
      'eventTime': eventTime.millisecondsSinceEpoch,
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
}
