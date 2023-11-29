// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../model/chat.dart';
import '../../services/socket_service.dart';

class MessageDetailPage extends StatefulWidget {
  final Chat chat;
  final Offset position;
  MessageDetailPage({Key? key, required this.chat, required this.position})
      : super(key: key);
  final f = DateFormat('hh:mm a');

  @override
  State<MessageDetailPage> createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  bool showAlreadyRead = false;
  final readTime = DateFormat('MMM d,h:mm a');
  List readUsers = ['名稱1', '名稱2', '名稱3', '名稱4', '名稱5', '名稱6'];
  String userMallLocal = 'qqq';

  @override
  Widget build(BuildContext context) {
    bool isSendByUser = widget.chat.userMall == userMallLocal;
    if (widget.chat.userId == null) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.chat.messageContent ?? '',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.blueGrey,
          child: Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
              ),
              Positioned(
                left: isSendByUser ? null : 16,
                right: isSendByUser ? 16 : null,
                top: widget.position.dy,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Column(
                    crossAxisAlignment: isSendByUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        (widget.chat.userMall ?? ''),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        constraints: BoxConstraints(
                          maxWidth: size.width * 0.5,
                          minWidth: size.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isSendByUser
                                ? Colors.blue
                                : Colors.grey.shade500),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isSendByUser)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                  radius: 8,
                                  child: Icon(Icons.person, size: 10),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                widget.chat.messageContent ?? 'none',
                                style: const TextStyle(color: Colors.white),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.f.format(
                            DateTime.parse(widget.chat.messageSendTime ?? '')),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: isSendByUser ? null : widget.position.dx,
                right: isSendByUser ? widget.position.dx : null,
                top: widget.position.dy + 72,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width * 0.6, // 控制框框的最大宽度
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          if (!showAlreadyRead)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.check, color: Colors.yellow),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showAlreadyRead = true;
                                      });
                                    },
                                    icon: Icon(Icons.people))
                              ],
                            ),
                          if (!showAlreadyRead)
                            InkWell(
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(
                                    text: widget.chat.messageContent ?? ''));
                                Navigator.of(context).pop(); // 返回聊天室页面
                              },
                              child: const ListTile(
                                leading: Icon(Icons.copy),
                                title: Text('複製'),
                              ),
                            ),
                          if (!showAlreadyRead)
                            InkWell(
                              onTap: () {
                                Map<String, dynamic> myMap = {};
                                myMap['key1'] = widget.chat.messageContent!;
                                myMap['key2'] = widget.chat.userMall;
                                Navigator.of(context).pop(myMap);
                              },
                              child: const ListTile(
                                leading: Icon(Icons.reply),
                                title: Text('回覆'),
                              ),
                            ),
                          if (!showAlreadyRead && isSendByUser)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  SocketService.returnMessage();
                                });

                                print('已收回');
                                Navigator.of(context).pop('收回');
                              },
                              child: const ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('收回'),
                              ),
                            ),
                          Visibility(
                            visible: showAlreadyRead,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showAlreadyRead = false;
                                        });
                                      },
                                      icon: Icon(Icons.arrow_back),
                                    ),
                                    Text('返回'),
                                    Divider(
                                      height: 20,
                                      thickness: 5,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: readUsers.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                                title: Row(
                                              children: [
                                                Icon(Icons.person), // 这里是图标
                                                SizedBox(width: 8), // 添加一些间距
                                                Column(
                                                  children: [
                                                    Text(readUsers[index]),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.done_all),
                                                        Text(
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                            readTime.format(
                                                                DateTime
                                                                    .now())),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
