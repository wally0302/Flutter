import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';

import '../model/friend.dart';

class Event {
  final String title;
  final String description;
  final DateTime eventStartTime;
  final DateTime eventEndTime;
  final Color backgroundColor;
  final String location;
  final String remark;
  final int notification;
  final bool enableNotification;
  final List<Friend> invitedFriends;
  final DateTime deadline;
  final int selectedHour;
  final int selectedMinute;
  final DateTime BeginDate; //活動預計開始時間
  final bool Isthecreator; //判斷是否為創建者
  final String Uid; //紀錄活動創建者的Uid

  const Event({
    required this.title,
    required this.description,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.invitedFriends,
    required this.deadline,
    required this.BeginDate,
    this.backgroundColor = Colors.black,
    this.location = '',
    this.remark = '',
    this.notification = 0,
    this.enableNotification = true,
    this.Isthecreator = true,
    this.selectedHour = 0,
    this.selectedMinute = 0,
    this.Uid = '',
  });

  get start => null;

  get date => null;
}
