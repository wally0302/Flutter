import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

class Vote {
  final int vID;
  final int? eID;
  final String? userMall;
  final String voteName;
  final DateTime endTime;
  final bool singleOrMultipleChoice;

  // 构造函数，用于初始化对象
  const Vote({
    required this.vID,
    required this.eID,
    required this.userMall,
    required this.voteName,
    required this.endTime,
    required this.singleOrMultipleChoice,
  });

  get start => null;

  factory Vote.fromMap(Map<String, dynamic> map) {
    int endTimeInt = map['endTime'];

    DateTime endTime = DateTime(
        endTimeInt ~/ 100000000, // 年
        (endTimeInt % 100000000) ~/ 1000000, // 月
        (endTimeInt % 1000000) ~/ 10000, // 日
        (endTimeInt % 10000) ~/ 100, // 小时
        endTimeInt % 100 // 分钟
        );
    return Vote(
      vID: map['vID'],
      eID: map['eID'],
      userMall: map['userMall'],
      voteName: map['voteName'],
      endTime: endTime,
      singleOrMultipleChoice: map['singleOrMultipleChoice'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vID': vID,
      'eID': eID,
      'userMall': userMall,
      'voteName': voteName,
      'endTime': endTime.year * 100000000 +
          endTime.month * 1000000 +
          endTime.day * 10000 +
          endTime.hour * 100 +
          endTime.minute, // 將 DateTime 轉換為 ISO 8601 字串
      'singleOrMultipleChoice': singleOrMultipleChoice ? 1 : 0,
    };
  }
}

class VoteOption {
  final int oID;
  final int? vID;
  final List<String> votingOptionContent;
  // final List<int> optionVotes;

  const VoteOption({
    required this.oID,
    required this.vID,
    required this.votingOptionContent,
    // required this.optionVotes,
  });

  get start => null;

  factory VoteOption.fromMap(Map<String, dynamic> map) {
    return VoteOption(
      oID: map['oID'],
      vID: map['vID'],
      votingOptionContent: [map['votingOptionContent']],
      // optionVotes: [map['optionVotes']],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vID': vID,
      'votingOptionContent': votingOptionContent,
      // 'optionVotes': optionVotes,
    };
  }
}

class VoteResult {
  final int voteResultID;
  final int? vID;
  final String? userMall;
  final int? oID;
  final bool status;

  const VoteResult({
    required this.voteResultID,
    required this.vID,
    required this.userMall,
    required this.oID,
    required this.status,
  });

  get start => null;

  Map<String, dynamic> toMap() {
    return {
      'vID': vID,
      'userMall': userMall,
      'oID': oID,
      'status': status ? 1 : 0,
    };
  }
}
