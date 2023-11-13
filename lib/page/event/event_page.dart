// 活動列表頁面

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:create_event2/page/event/event_editing_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../bottom_bar.dart';
import '../../model/event.dart';
import '../../provider/event_provider.dart';
import '../../services/sqlite.dart';
import '../login_page.dart';
import 'event_viewing_page.dart';
import '../chat_room_page.dart'; // 引入聊天室頁面
import '../../services/http.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> eventlist = [];
  List<Event> notMatchTime = []; //媒合時間尚未到
  List<Event> yesMatchTime = []; //媒合時間到了 -> 就要開始媒合

  @override
  void initState() {
    super.initState();
    getHomeCalendarDateEvent();
    getGuestCalendarDateEvent();
    startCronJob();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 隱藏返回鍵
          title: const Text('活動列表', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Color(0xFF4A7DAB), // 修改 AppBar 的背景颜色

          // leading: IconButton(
          //   // X 按鈕
          //   icon: const Icon(Icons.close, color: Colors.black),
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/MyBottomBar2');
          //   },
          // ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventEditingPage(
                      addTodayDate: false,
                      time: DateTime.now(),
                      event: null,
                    ),
                  ),
                );

                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('活動已新增'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "媒合時間未到",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notMatchTime.length,
                  itemBuilder: (context, index) {
                    final event = notMatchTime[index];
                    // 构建 notMatchTime 事件的 UI
                    return buildEventTile(event, context, false);
                  },
                ),
              ),
              Divider(
                thickness: 5,
                color: Colors.black,
              ), // 加粗分隔线
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "媒合時間已到",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: yesMatchTime.length,
                  itemBuilder: (context, index) {
                    final event = yesMatchTime[index];
                    return buildEventTile(event, context, true);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildEventTile(
      Event event, BuildContext context, bool isMatchTimePassed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 340,
        height: 75,
        decoration: ShapeDecoration(
          color: Color(0xFFCFE3F4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: ListTile(
          title: Text(
            isMatchTimePassed
                ? '${DateFormat('MMdd').format(event.eventBlockStartTime)} ~ ${DateFormat('MMdd').format(event.eventBlockEndTime)} ${event.eventName}'
                : event.eventName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            event.location,
            style: TextStyle(fontSize: 16),
          ),
          onTap: () async {
            final action = await showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                insetPadding: EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  width: 240,
                  height: 90,
                  decoration: ShapeDecoration(
                    color: Color(0xFF517B92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('view');
                        },
                        child: Container(
                          width: 120,
                          height: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/page.png',
                                  width: 30, height: 30),
                              Text(
                                '詳細資訊',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'DFKai-SB',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('chat');
                        },
                        child: Container(
                          width: 120,
                          height: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/message.png',
                                  width: 30, height: 30),
                              Text(
                                '聊天室',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'DFKai-SB',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            if (action == 'view') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventViewingPage(
                    event: event,
                    show: isMatchTimePassed,
                  ),
                ),
              );
            } else if (action == 'chat') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomPage(),
                ),
              );
            }
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
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

              // 如果用户确认删除
              if (confirmDelete == true) {
                var userMall = {'userMall': FirebaseEmail}; //到时候要改成登录的用户
                await APIservice.deleteEvent(
                    content: userMall, eID: event.eID.toString());

                setState(() {
                  eventlist.remove(event);
                  notMatchTime.remove(event);
                  yesMatchTime.remove(event);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('活動已刪除'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  //抓 "房主" 的 event 資料
  getHomeCalendarDateEvent() async {
    // 從server抓使用者行事曆資料
    var userMall = {'userMall': FirebaseEmail};
    final result = await APIservice.selectHomeEventAll(
        content: userMall,
        userMall: FirebaseEmail!); // 從 server 抓使用者行事曆資料，就會把資料存入 sqlite
    print(
        '------------------------------------------------------------------------------');
    print("該 $userMall 的資料: $result"); //，是一個陣列 [{}, {}, {}]
    print(
        '------------------------------------------------------------------------------');
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable =
        await Sqlite.queryAll(tableName: 'event'); // 從 sqlite 拿資料
    queryCalendarTable ??= []; // 如果沒有資料，就給一個空陣列
    DateTime now = DateTime.now(); //現在時間

    setState(() {
      eventlist = queryCalendarTable!
          .map((e) => Event.fromMap(e))
          .toList(); //將 queryCalendarTable 轉換成 Event 物件的 List，讓 SfCalendar 可以顯示
    });
    for (var event in eventlist) {
      if (now.isAfter(event.matchTime)) {
        yesMatchTime.add(event);
      } else {
        notMatchTime.add(event);
      }
    }

    return queryCalendarTable;
  }

  //抓 使用者有參與 的 event 資料
  getGuestCalendarDateEvent() async {
    // 從server抓使用者行事曆資料
    var userMall = {'userMall': FirebaseEmail};
    final result = await APIservice.selectGuestEventAll(
        content: userMall,
        guestMall: FirebaseEmail!); // 從 server 抓使用者行事曆資料，就會把資料存入 sqlite
    print(
        '------------------------------------------------------------------------------');
    print("該$userMall 參與的 event : $result"); //，是一個陣列 [{}, {}, {}]
    print(
        '------------------------------------------------------------------------------');
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable =
        await Sqlite.queryAll(tableName: 'event'); // 從 sqlite 拿資料
    queryCalendarTable ??= []; // 如果沒有資料，就給一個空陣列
    DateTime now = DateTime.now(); //現在時間

    setState(() {
      eventlist = queryCalendarTable!
          .map((e) => Event.fromMap(e))
          .toList(); //將 queryCalendarTable 轉換成 Event 物件的 List，讓 SfCalendar 可以顯示
    });
    for (var event in eventlist) {
      if (now.isAfter(event.matchTime)) {
        yesMatchTime.add(event);
      } else {
        notMatchTime.add(event);
      }
    }

    return queryCalendarTable;
  }

  void startCronJob() {
    var cron = Cron();
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      await checkMatchTime();
    });
  }

  Future<void> checkMatchTime() async {
    DateTime now = DateTime.now();
    for (var event in eventlist) {
      if (now.isAtSameMomentAs(event.matchTime) ||
          (now.isAfter(event.matchTime) && !yesMatchTime.contains(event))) {
        print('${event.eventName} 的媒合時間已到達');
        // 媒合時間到了，就要開始媒合，觸發 後端 API
        setState(() {
          if (!yesMatchTime.contains(event)) {
            yesMatchTime.add(event);
            notMatchTime.remove(event);
          }
        });
      }
    }
  }
}
