import 'package:flutter/material.dart';

class Journey {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final String location;
  final String remark;
  final int notification;
  final bool enableNotification;
  final bool isAllDay; //整天

  const Journey({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.black,
    this.location = '',
    this.remark = '',
    this.notification = 0,
    this.enableNotification = true,
    this.isAllDay = false,
  });

  get start => null;
}
