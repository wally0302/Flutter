// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../../model/chat.dart';
import 'message_detail_page.dart';

// typedef MessageDataCallback = void Function(Map<String, dynamic> data);

class MessageView extends StatefulWidget {
  final Chat chat;
  // final MessageDataCallback? onDataReceived;
  // final ValueChanged<String> onSwipedMessage;

  MessageView({
    Key? key,
    required this.chat,
    // this.onDataReceived,
    //required this.onSwipedMessage
  }) : super(key: key);
  final f = DateFormat('hh:mm a');

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  GlobalKey globalKey = GlobalKey();
  String returnMessage = 'false';
  String userMallLocal = '';

  @override
  void initState() {
    super.initState();
    // print(SocketService.userId);
    setState(() {
      returnMessage = widget.chat.returnMessage ?? 'false';
      print('初始化rM$returnMessage');
    });
    userMallLocal = 'qqq';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSendByUser = widget.chat.userMall == userMallLocal;

    var size = MediaQuery.of(context).size;

    return GestureDetector(
      key: globalKey,
      onLongPress: () async {
        RenderBox renderBox =
            globalKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailPage(
              chat: widget.chat,
              position: position,
            ),
          ),
        );
        print('返回result$result');
        if (result != null) {
          if (result == '收回') {
            setState(() {
              returnMessage = 'true';
            });
            setState(() {});
          }
        }
      },
      child: (widget.chat.messageContent == null)
          ? Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                children: <Widget>[
                  if (widget.chat.activityName != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ('系統訊息'),
                          style: TextStyle(
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
                              color: Colors.grey.shade500),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                  child: Text(
                                '${widget.chat.activityName}活動',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'DFKai-SB',
                                    fontSize: 20,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                              const SizedBox(height: 2),
                              const Divider(height: 1.0, color: Colors.black),
                              const SizedBox(height: 2),
                              Flexible(
                                child: Text(
                                  '時間:${widget.chat.activityTime}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'DFKai-SB',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Flexible(
                                child: Text(
                                  '地點:${widget.chat.activityLocation}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'DFKai-SB',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Flexible(
                                child: Text(
                                  '參加成員:${widget.chat.activityMemberName}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'DFKai-SB',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (widget.chat.activityVote != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ('系統訊息'),
                          style: TextStyle(
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
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.transparent),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                  child: Text(
                                '媒合結果投票',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'DFKai-SB',
                                    fontSize: 20,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                              const SizedBox(height: 2),
                              const Divider(height: 1.5, color: Colors.black),
                              const SizedBox(height: 4),
                              Flexible(
                                child: Text(
                                  '請前往投票列表投票',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'DFKai-SB',
                                      fontSize: 18,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(height: 1),
                              ElevatedButton(
                                  onPressed: null, child: Text('立即投票'))
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            )
          : Align(
              alignment: (returnMessage == 'false')
                  ? (isSendByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft)
                  : Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: (returnMessage == 'true')
                    ? (isSendByUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start)
                    : CrossAxisAlignment.center,
                children: [
                  if (returnMessage == 'true')
                    Text(
                      '${widget.chat.userMall ?? ''} 已收回了訊息', // 显示谁收回了消息
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (returnMessage == 'false')
                    Text(
                      (widget.chat.userMall ?? ''),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 4),
                  if (returnMessage == 'false')
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isSendByUser)
                              Text(
                                '已讀 1',
                                style: TextStyle(fontSize: 10),
                              ),
                            if (isSendByUser)
                              Text(
                                widget.f.format(DateTime.parse(
                                    widget.chat.messageSendTime ?? '')),
                                style: const TextStyle(fontSize: 10),
                              ),
                          ],
                        ),
                        SizedBox(
                          width: 6,
                        ),
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
                                    child: Icon(Icons.person, size: 10),
                                    radius: 8,
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
                        SizedBox(
                          width: 6,
                        ),
                        if (!isSendByUser)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.f.format(DateTime.parse(
                                    widget.chat.messageSendTime ?? '')),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
    );
  }
}
