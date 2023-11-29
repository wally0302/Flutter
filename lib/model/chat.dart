import 'dart:convert';

class Chat {
  final String? userId;
  final int? mID; // 訊息id
  final int? chatID; // 聊天室id
  final String? userMall; // 訊息發送者名稱 但可能不用，直接去資料庫抓

  final String? messageContent; // 訊息內容
  final String? messageSendTime; // 訊息傳送時間
  // 收回訊息
  String? returnMessage;
  // 回復訊息
  // String? replyMessage;

  final Chat? replyMessage;

  // 這幾個不用存資料庫
  final String? activityName;
  final String? activityTime;
  final String? activityLocation;
  final String? activityMemberName;
  final String? activityVote;
  //

  Chat(
      {this.userId,
      this.mID,
      this.chatID,
      this.userMall,
      this.messageContent,
      this.messageSendTime,
      this.returnMessage,
      this.replyMessage,
      // required this.replyMessage,
      this.activityName,
      this.activityTime,
      this.activityLocation,
      this.activityMemberName,
      this.activityVote});

  static Chat fromRawJson(Map<String, dynamic> jsonData) {
    return Chat(
      userId: jsonData['userId'],
      mID: jsonData['mID'],
      userMall: jsonData['userMall'],
      messageContent: jsonData['messageContent'],
      messageSendTime: jsonData['messageSendTime'],
      returnMessage: jsonData['returnMessage'],
      replyMessage: jsonData['replyMessage'] == null
          ? null
          : Chat.fromRawJson(jsonData['replyMessage']),
      activityName: jsonData['activityName'],
      activityTime: jsonData['activityTime'],
      activityLocation: jsonData['activityLocation'],
      activityMemberName: jsonData['activityMemberName'],
      activityVote: jsonData['activityVote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "mID": mID,
      "userMall": userMall,
      "messageContent": messageContent,
      "messageSendTime": messageSendTime,
      "returnMessage": returnMessage,
      "replyMessage": replyMessage == null ? null : replyMessage!.toJson(),
      "activityName": activityName,
      "activityTime": activityTime,
      "activityLocation": activityLocation,
      "activityMemberName": activityMemberName,
      "activityVote": activityVote,
    };
  }
}
