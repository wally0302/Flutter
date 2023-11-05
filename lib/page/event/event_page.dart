// 活動列表頁面

import 'package:flutter/material.dart';
import 'package:create_event2/page/event/event_editing_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../bottom_bar.dart';
import '../../model/event.dart';
import '../../provider/event_provider.dart';
import 'event_viewing_page.dart';
import '../chat_room_page.dart'; // 引入聊天室頁面
import '../../services/http.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future<List<Event>>? _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = APIservice.getAllEvent(content: {}).then((result) {
      // print(result[1]); //印出資料庫所有的活動
      // return result[1];
      List<Map<String, dynamic>> rawData =
          List<Map<String, dynamic>>.from(result[1]);
      print(rawData);
      return rawData.map((eventMap) => Event.fromMap(eventMap)).toList();
    });
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
          child: FutureBuilder<List<Event>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // 顯示載入指示器
              } else if (snapshot.hasError || snapshot.data == null) {
                return Center(child: Text('資料載入失敗')); // 載入失敗時的界面
              } else {
                final sortedActivities = snapshot.data!;

                if (sortedActivities.isEmpty) {
                  return Center(
                    child: Text('目前無任何活動'),
                  );
                }
                return ListView.builder(
                  itemCount: sortedActivities.length,
                  itemBuilder: (context, index) {
                    final event = sortedActivities[index];
                    final formattedStartDate =
                        DateFormat('MMdd').format(event.eventBlockStartTime);
                    final formattedEndDate =
                        DateFormat('MMdd').format(event.eventBlockEndTime);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        width: 340,
                        height: 75,
                        decoration: ShapeDecoration(
                          color: Color(0xFFCFE3F4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: ListTile(
                          title: Text(
                            '$formattedStartDate ~ $formattedEndDate ${event.eventName}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            event.location,
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () async {
                            final action = await showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                insetPadding: EdgeInsets.all(
                                    0), // Remove any padding from the Dialog
                                backgroundColor: Colors
                                    .transparent, // Make Dialog background transparent
                                elevation: 0, // Remove shadow
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop('view');
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 90,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/page.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                              Text(
                                                '詳細資訊',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: 'DFKai-SB',
                                                  fontWeight: FontWeight.w400,
                                                ),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/message.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                              Text(
                                                '聊天室',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: 'DFKai-SB',
                                                  fontWeight: FontWeight.w400,
                                                ),
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
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    width: 245,
                                    height: 160,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF517B92),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('確認刪除',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        SizedBox(height: 20),
                                        Text('確定要刪除這個活動嗎？',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('取消',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            // TextButton(
                                            //   onPressed: () {
                                            //     eventProvider.deleteEvent(event);
                                            //     Navigator.of(context).pop();
                                            //   },
                                            //   child: Text('確定',
                                            //       style: TextStyle(
                                            //           color: Colors.white)),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )),
    );
  }
}
