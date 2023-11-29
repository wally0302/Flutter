import 'dart:math';

import 'package:create_event2/model/event.dart';
import 'package:create_event2/services/sqlite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../model/friend.dart';
import '../model/journey.dart';

class APIservice {
  // 將 userMall & userMall  傳給 server
  static Future<List<dynamic>> signIn(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/user/signUp");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  ////////////////////// 行程(journey) //////////////////////
  // 新增行程 ok
  static Future<List<dynamic>> addJourney(
      {required Map<String, dynamic> content}) async {
    final url =
        Uri.parse("http://163.22.17.145:3000/api/journey/insertJourney");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  // 編輯行程 ok
  static Future<List<dynamic>> editJourney(
      {required Map<String, dynamic> content, required int jID}) async {
    String url =
        "http://163.22.17.145:3000/api/journey/updateJourney/$jID"; //api後接檔案名稱
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      print('編輯行程成功');
      return [true, response];
    } else {
      print(response);
      return [false, response];
    }
  }

  //刪除行程 ok
  static Future<List<dynamic>> deleteJourney(
      {required Map<String, dynamic> content, required int jID}) async {
    String url =
        "http://163.22.17.145:3000/api/journey/deleteJourney/$jID"; //api後接檔案名稱
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    ); // 根據使用者的token新增資料
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('刪除行程成功');
      return [true, responseString];
    } else {
      print(responseString);
      return [false, responseString];
    }
  }

  // 抓使用者行事曆所有的 journey ，還會把資料存入 sqlite  ok
  static Future<List<dynamic>> selectJourneyAll(
      {required Map<String, dynamic> content, required String userMall}) async {
    final url = Uri.parse(
        "http://163.22.17.145:3000/api/journey/getAllJourney/$userMall");
    // await Sqlite.clear(tableName: "journey"); // 清空資料表
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final serverJourney = jsonDecode(response.body); //是一個 List<dynamic>
    if (response.statusCode == 200 || response.statusCode == 400) {
      // 是將從 server 取得的行程資料轉換成本地端的 Event 物件，以便在本地端顯示行程
      for (var journey in serverJourney) {
        // 從資料庫抓出來的時間轉成int
        int journeyStartTimeInt = journey['journeyStartTime'];
        // print('--old---');
        // print(journeyStartTimeInt);//202311051242
        int journeyEndTimeInt = journey['journeyEndTime'];
        final Journey newJourneyData = Journey(
            jID: journey['jID'],
            userMall: journey['userMall'],
            journeyName: journey['journeyName'].toString(),
            journeyStartTime: DateTime(
                //2023-11-05 12:42:00.000
                journeyStartTimeInt ~/ 100000000, // 年
                (journeyStartTimeInt % 100000000) ~/ 1000000, // 月
                (journeyStartTimeInt % 1000000) ~/ 10000, // 日
                (journeyStartTimeInt % 10000) ~/ 100, // 小时
                journeyStartTimeInt % 100 // 分钟
                ),
            journeyEndTime: DateTime(
                journeyEndTimeInt ~/ 100000000, // 年
                (journeyEndTimeInt % 100000000) ~/ 1000000, // 月
                (journeyEndTimeInt % 1000000) ~/ 10000, // 日
                (journeyEndTimeInt % 10000) ~/ 100, // 小时
                journeyEndTimeInt % 100 //
                ),
            color: Color(journey['color']),
            location: journey['location'],
            remark: journey['remark'],
            remindTime: journey['remindTime'],
            remindStatus:
                journey['remindStatus'] == 1, // "==1" 將資料庫的 0, 1 轉成 bool
            isAllDay: journey['isAllDay'] == 1);
        // print('--new---');
        // print(newJourneyData.journeyStartTime);
        Sqlite.insert(
            tableName: 'journey',
            insertData: newJourneyData.toMap()); // 將資料存入本地端資料庫
      }
      print('完成 刷新 sqlite 活動資料表');
      return serverJourney;
    } else {
      print('失敗 刷新 sqlite 活動資料表');
      print('失敗 $serverJourney response.statusCode ${response.statusCode}');
      return serverJourney;
    }
  }

  ////////////////////// 活動(event) //////////////////////

  //新增活動 ok
  static Future<List<dynamic>> addEvent(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/event/insertEvent");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  // 抓房主行事曆所有的 event ，還會把資料存入 sqlite
  static Future<List<dynamic>> selectHomeEventAll(
      {required Map<String, dynamic> content, required String userMall}) async {
    final url =
        Uri.parse("http://163.22.17.145:3000/api/event/getAllEvent/$userMall");

    await Sqlite.clear(tableName: "event"); // 清空資料表
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final serverEvent = jsonDecode(response.body); //是一個 List<dynamic>
    // print('---serverEvent---');
    // print(serverEvent);

    if (response.statusCode == 200 || response.statusCode == 400) {
      for (var event in serverEvent) {
        int eventBlockStartTimeInt = event['eventBlockStartTime'];
        int eventBlockEndTimeInt = event['eventBlockEndTime'];
        int eventFinalStartTimeInt = event['eventFinalStartTime'];
        int eventFinalEndTimeInt = event['eventFinalEndTime'];
        int matchTimeInt = event['matchTime'];
        int eventTimeInt = event['eventTime'];
        int timeLengthHoursInt = event['timeLengthHours'];
        String friendsString = event['friends']; //wally,jack
        List<String> friendsList = friendsString.split(','); //["wally", "jack"]
        List<Friend> friendObjects =
            friendsList.map((name) => Friend.fromName(name)).toList();
        int remindTimeInt = event['remindTime'];
        final Event newEventData = Event(
          eID: event['eID'],
          userMall: event['userMall'],
          //名稱
          eventName: event['eventName'].toString(),

          // 匹配起始日
          eventBlockStartTime: DateTime(
              eventBlockStartTimeInt ~/ 100000000, // 年
              (eventBlockStartTimeInt % 100000000) ~/ 1000000, // 月
              (eventBlockStartTimeInt % 1000000) ~/ 10000, // 日
              (eventBlockStartTimeInt % 10000) ~/ 100, // 小时
              eventBlockStartTimeInt % 100 //
              ),

          // 匹配結束日
          eventBlockEndTime: DateTime(
              eventBlockEndTimeInt ~/ 100000000, // 年
              (eventBlockEndTimeInt % 100000000) ~/ 1000000, // 月
              (eventBlockEndTimeInt % 1000000) ~/ 10000, // 日
              (eventBlockEndTimeInt % 10000) ~/ 100, // 小时
              eventBlockEndTimeInt % 100 //
              ),
          //活動預計開始時間
          eventTime: DateTime(
              eventTimeInt ~/ 100000000, // 年
              (eventTimeInt % 100000000) ~/ 1000000, // 月
              (eventTimeInt % 1000000) ~/ 10000, // 日
              (eventTimeInt % 10000) ~/ 100, // 小时
              eventTimeInt % 100 // 分钟
              ),
          //活動預計時間長度
          timeLengthHours: timeLengthHoursInt,
          //地點
          location: event['location'],
          //備註
          remark: event['remark'],
          //參加好友
          friends: friendObjects,
          //媒合開始時間
          matchTime: DateTime(
              matchTimeInt ~/ 100000000, // 年
              (matchTimeInt % 100000000) ~/ 1000000, // 月
              (matchTimeInt % 1000000) ~/ 10000, // 日
              (matchTimeInt % 10000) ~/ 100, // 小时
              matchTimeInt % 100 // 分钟
              ),
          //提醒是否開 1:開啟 0:關閉
          remindStatus: event['remindStatus'] == 1,
          //提醒時間
          remindTime: DateTime(
              remindTimeInt ~/ 100000000, // 年
              (remindTimeInt % 100000000) ~/ 1000000, // 月
              (remindTimeInt % 1000000) ~/ 10000, // 日
              (remindTimeInt % 10000) ~/ 100, // 小时
              remindTimeInt % 100 // 分钟
              ),
          //-------------------------------------------
          //後端會回傳給前端的資料
          //1:已完成媒合 0:未完成媒合
          state: event['state'],
          //最終確定時間 年月日時分
          eventFinalStartTime: DateTime(
              eventFinalStartTimeInt ~/ 100000000, // 年
              (eventFinalStartTimeInt % 100000000) ~/ 1000000, // 月
              (eventFinalStartTimeInt % 1000000) ~/ 10000, // 日
              (eventFinalStartTimeInt % 10000) ~/ 100, // 小时
              eventFinalStartTimeInt % 100 // 分钟
              ),
          eventFinalEndTime: DateTime(
              eventFinalEndTimeInt ~/ 100000000, // 年
              (eventFinalEndTimeInt % 100000000) ~/ 1000000, // 月
              (eventFinalEndTimeInt % 1000000) ~/ 10000, // 日
              (eventFinalEndTimeInt % 10000) ~/ 100, // 小时
              eventFinalEndTimeInt % 100 // 分钟
              ),
        );

        // print('---newEventData---');
        // print(newEventData);
        // //要取得時間後面再加上 .day .hour .minute
        // print(newEventData.eventBlockStartTime.day);
        // print(newEventData.eventBlockEndTime.hour);

        Sqlite.insert(
            tableName: 'event',
            insertData: newEventData.toMap()); // 將資料存入本地端資料庫
      }
      print('完成 刷新 sqlite home行程資料表');
      // print('serverEvent $serverEvent');
      return serverEvent;
    } else {
      print('失敗 刷新 sqlite home行程資料表');
      return serverEvent;
    }
  }

  // 抓 使用者有參與 的 event 資料
  static Future<List<dynamic>> selectGuestEventAll(
      {required Map<String, dynamic> content,
      required String guestMall}) async {
    final url = Uri.parse(
        "http://163.22.17.145:3000/api/event/getEventByFriend/$guestMall");

    // await Sqlite.clear(tableName: "event"); // 清空資料表
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final serverGuestEvent = jsonDecode(response.body); //是一個 List<dynamic>
    print('---serverGuestEvent---');
    print(serverGuestEvent);
    if (response.statusCode == 200 || response.statusCode == 400) {
      for (var event in serverGuestEvent) {
        int eventBlockStartTimeInt = event['eventBlockStartTime'];
        int eventBlockEndTimeInt = event['eventBlockEndTime'];
        int eventFinalStartTimeInt = event['eventFinalStartTime'];
        int eventFinalEndTimeInt = event['eventFinalEndTime'];
        int matchTimeInt = event['matchTime'];
        int eventTimeInt = event['eventTime'];
        int timeLengthHoursInt = event['timeLengthHours'];
        String friendsString = event['friends']; //wally,jack
        List<String> friendsList = friendsString.split(','); //["wally", "jack"]
        List<Friend> friendObjects =
            friendsList.map((name) => Friend.fromName(name)).toList();
        int remindTimeInt = event['remindTime'];
        final Event newEventData = Event(
          eID: event['eID'],
          userMall: event['userMall'],
          //名稱
          eventName: event['eventName'].toString(),

          // 匹配起始日
          eventBlockStartTime: DateTime(
              eventBlockStartTimeInt ~/ 100000000, // 年
              (eventBlockStartTimeInt % 100000000) ~/ 1000000, // 月
              (eventBlockStartTimeInt % 1000000) ~/ 10000, // 日
              (eventBlockStartTimeInt % 10000) ~/ 100, // 小时
              eventBlockStartTimeInt % 100 //
              ),

          // 匹配結束日
          eventBlockEndTime: DateTime(
              eventBlockEndTimeInt ~/ 100000000, // 年
              (eventBlockEndTimeInt % 100000000) ~/ 1000000, // 月
              (eventBlockEndTimeInt % 1000000) ~/ 10000, // 日
              (eventBlockEndTimeInt % 10000) ~/ 100, // 小时
              eventBlockEndTimeInt % 100 //
              ),
          //活動預計開始時間
          eventTime: DateTime(
              eventTimeInt ~/ 100000000, // 年
              (eventTimeInt % 100000000) ~/ 1000000, // 月
              (eventTimeInt % 1000000) ~/ 10000, // 日
              (eventTimeInt % 10000) ~/ 100, // 小时
              eventTimeInt % 100 // 分钟
              ),
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
          matchTime: DateTime(
              matchTimeInt ~/ 100000000, // 年
              (matchTimeInt % 100000000) ~/ 1000000, // 月
              (matchTimeInt % 1000000) ~/ 10000, // 日
              (matchTimeInt % 10000) ~/ 100, // 小时
              matchTimeInt % 100 // 分钟
              ),
          //提醒是否開 1:開啟 0:關閉
          remindStatus: event['remindStatus'] == 1,
          //提醒時間
          remindTime: DateTime(
              remindTimeInt ~/ 100000000, // 年
              (remindTimeInt % 100000000) ~/ 1000000, // 月
              (remindTimeInt % 1000000) ~/ 10000, // 日
              (remindTimeInt % 10000) ~/ 100, // 小时
              remindTimeInt % 100 // 分钟
              ),
          //-------------------------------------------
          //後端會回傳給前端的資料
          //1:已完成媒合 0:未完成媒合
          state: event['state'],
          //最終確定時間 年月日時分
          eventFinalStartTime: DateTime(
              eventFinalStartTimeInt ~/ 100000000, // 年
              (eventFinalStartTimeInt % 100000000) ~/ 1000000, // 月
              (eventFinalStartTimeInt % 1000000) ~/ 10000, // 日
              (eventFinalStartTimeInt % 10000) ~/ 100, // 小时
              eventFinalStartTimeInt % 100 // 分钟
              ),
          eventFinalEndTime: DateTime(
              eventFinalEndTimeInt ~/ 100000000, // 年
              (eventFinalEndTimeInt % 100000000) ~/ 1000000, // 月
              (eventFinalEndTimeInt % 1000000) ~/ 10000, // 日
              (eventFinalEndTimeInt % 10000) ~/ 100, // 小时
              eventFinalEndTimeInt % 100 // 分钟
              ),
        );

        // //要取得時間後面再加上 .day .hour .minute
        // print(newEventData.eventBlockStartTime.day);
        // print(newEventData.eventBlockEndTime.hour);
        Sqlite.insert(
            tableName: 'event',
            insertData: newEventData.toMap()); // 將資料存入本地端資料庫
      }
      print('完成 刷新 sqlite guest行程資料表');
      return serverGuestEvent;
    } else {
      print('失敗 刷新 sqlite guest行程資料表');
      return [];
    }
  }

  //房主刪除活動 透過 eid 刪除
  static Future<List<dynamic>> deleteHomeEvent(
      {required Map<String, dynamic> content, required String eID}) async {
    final url =
        Uri.parse("http://163.22.17.145:3000/api/event/deleteEvent/$eID");
    final response = await http.delete(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  //客人刪除活動 透過 eid & mail  刪除
  static Future<List<dynamic>> deleteGuestEvent(
      {required Map<String, dynamic> content,
      required String eID,
      required String userMall}) async {
    final url = Uri.parse(
        "http://163.22.17.145:3000/api/event/deleteMyselfFromEvent/$eID/$userMall");
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  // 編輯活動 ok
  static Future<List<dynamic>> editEvent(
      {required Map<String, dynamic> content, required String eID}) async {
    String url = "http://163.22.17.145:3000/api/event/updateEvent/$eID";
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      print('編輯活動成功');
      return [true, response];
    } else {
      print(response);
      return [false, response];
    }
  }

  ////////////////////// 投票(vote) //////////////////////
  // 新增投票
  static Future<List<dynamic>> addVote(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/vote/insertVote/");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  // 新增投票選項
  static Future<List<dynamic>> addVoteOptions(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse(
        "http://163.22.17.145:3000/api/votingOption/insertVotingOption/");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  // 新增投票結果
  static Future<List<dynamic>> addVoteResult(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/result/insertResult/");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('新增投票結果成功');
      return [true, responseString];
    } else {
      print('新增投票結果失敗');
      return [false, response];
    }
  }

  // 刪除投票
  static Future<List<dynamic>> deleteVote({required int vID}) async {
    String url =
        "http://163.22.17.145:3000/api/vote/deleteVote/$vID"; //api後接檔案名稱
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
    ); // 根據使用者的token新增資料
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('刪除投票成功');
      return [true, responseString];
    } else {
      print(responseString);
      return [false, responseString];
    }
  }

  // 刪除投票選項
  static Future<List<dynamic>> deleteVoteOptions({required int vID}) async {
    String url =
        "http://163.22.17.145:3000/api/votingOption/deleteVotingOption/$vID"; //api後接檔案名稱
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      // body: jsonEncode(content),
    ); // 根據使用者的token新增資料
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('刪除投票選項成功');
      return [true, responseString];
    } else {
      print(responseString);
      return [false, responseString];
    }
  }

  // 更新投票結果
  static Future<List<dynamic>> updateResult(
      {required Map<String, dynamic> content,
      required int voteResultID}) async {
    String url =
        "http://163.22.17.145:3000/api/result/updateResult/$voteResultID"; //api後接檔案名稱
    print("---------------SQL-------------");
    print(content);
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    ); // 根據使用者的token新增資料

    print('API 返回的內容: ${response.body}'); // 添加這行
    final responseString = response.body;
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('更改投票選項成功');
      return [true, responseString];
    } else {
      print(responseString);
      return [false, responseString];
    }
  }

  // 計算投票總票數
  static Future<List<dynamic>> countVote({required int oID}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/result/count/$oID");
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      //body: jsonEncode(content),
    );
    final serverVote = jsonDecode(response.body);
    print(serverVote);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('計算投票總票數成功');
      return [true, serverVote];
    } else {
      print(serverVote);
      print('計算投票總票數失敗');
      return [false, serverVote];
    }
  }

  // 抓全部投票列表
  static Future<List<dynamic>> seletallVote({required int eID}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/vote/getAllVote/$eID");
    //await Sqlite.clear(tableName: "vote");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      //body: jsonEncode(content),
    );
    final serverVote = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      // for (var vote in serverVote) {
      //   int endTimeInt = vote['endTime'];
      //   final Vote newVoteData = Vote(
      //       vID: vote['vID'],
      //       eID: vote['eID'],
      //       userMall: vote['userMall'],
      //       voteName: vote['voteName'].toString(),
      //       endTime: DateTime(
      //           endTimeInt ~/ 100000000, // 年
      //           (endTimeInt % 100000000) ~/ 1000000, // 月
      //           (endTimeInt % 1000000) ~/ 10000, // 日
      //           (endTimeInt % 10000) ~/ 100, // 小时
      //           endTimeInt % 100 // 分钟
      //           ),
      //       singleOrMultipleChoice: vote['isChecked'] == 1);
      //   Sqlite.insert(tableName: 'vote', insertData: newVoteData.toMap());
      // }
      //   print('完成 刷新 sqlite 投票資料表');
      //   return serverVote;
      // } else {
      //   print('失敗 刷新 sqlite 投票資料表');
      //   print('失敗 $serverVote response.statusCode ${response.statusCode}');
      //   return serverVote;
      // }
      print('抓取投票選項成功');
      return [true, serverVote];
    } else {
      print(serverVote);
      print('抓取投票選項失敗');
      return [false, serverVote];
    }
  }

  // 抓全部投票選項
  static Future<List<dynamic>> seletallVoteOptions({required int vID}) async {
    final url = Uri.parse(
        "http://163.22.17.145:3000/api/votingOption/getAllVotingOption/$vID");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      //body: jsonEncode(content),
    );
    final serverVote = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      // for (var vote in serverVote) {
      //   int endTimeInt = vote['endTime'];
      //   final Vote newVoteData = Vote(
      //       vID: vote['vID'],
      //       eID: vote['eID'],
      //       uID: vote['uID'],
      //       voteName: vote['voteName'].toString(),
      //       endTime: DateTime(
      //           endTimeInt ~/ 100000000, // 年
      //           (endTimeInt % 100000000) ~/ 1000000, // 月
      //           (endTimeInt % 1000000) ~/ 10000, // 日
      //           (endTimeInt % 10000) ~/ 100, // 小时
      //           endTimeInt % 100 // 分钟
      //           ),
      //       singleOrMultipleChoice: vote['isChecked'] == 1);
      //   // Sqlite.insert(tableName: 'vote', insertData: newVoteData.toMap());
      // }
      print('抓取投票選項成功');
      return [true, serverVote];
    } else {
      print(serverVote);
      return [false, serverVote];
    }
  }

  // 抓全部投票結果
  static Future<List<dynamic>> seletallVoteResult(
      {required int vID, required String userMall}) async {
    final url = Uri.parse(
        "http://163.22.17.145:3000/api/result/getAllResult/$vID/$userMall");
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      //body: jsonEncode(content),
    );
    final serverVote = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      // for (var vote in serverVote) {
      //   int endTimeInt = vote['endTime'];
      //   final Vote newVoteData = Vote(
      //       vID: vote['vID'],
      //       eID: vote['eID'],
      //       uID: vote['uID'],
      //       voteName: vote['voteName'].toString(),
      //       endTime: DateTime(
      //           endTimeInt ~/ 100000000, // 年
      //           (endTimeInt % 100000000) ~/ 1000000, // 月
      //           (endTimeInt % 1000000) ~/ 10000, // 日
      //           (endTimeInt % 10000) ~/ 100, // 小时
      //           endTimeInt % 100 // 分钟
      //           ),
      //       singleOrMultipleChoice: vote['isChecked'] == 1);
      //   // Sqlite.insert(tableName: 'vote', insertData: newVoteData.toMap());
      // }
      print('抓取投票結果成功');
      return [true, serverVote];
    } else {
      print(serverVote);
      return [false, serverVote];
    }
  }

  //媒合時間
  static Future<List<dynamic>> match(
      {required Map<String, dynamic> content, required String eID}) async {
    String url = "http://163.22.17.145:3000/api/match/$eID";
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('媒合時間成功');
      return [true, response];
    } else {
      print(response);
      return [false, response];
    }
  }
}
