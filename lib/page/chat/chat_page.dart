// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';

// import 'package:chatroom/utils/constants.dart';

import '../../model/chat.dart';
import '../../model/event.dart';
import '../../services/socket_service.dart';
import '../vote/vote_page.dart';
import 'message_view.dart';
// import 'package:chatroom/views/chat/chat_text_input.dart';
// import 'user_list_view.dart';
import 'reply_message.dart';
import 'package:flutter/services.dart';
import 'package:swipe_to/swipe_to.dart';

// ignore: library_private_types_in_public_api
// GlobalKey<_ChatTextInputState> chatTextInputKey =
//     GlobalKey<_ChatTextInputState>();
// Map<String, dynamic> returnReply = {};
// String? name = '';
// String? message = '';

class ChatPage extends StatefulWidget {
  final Event event;

  ChatPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final focusNode = FocusNode();
  // Map<String, dynamic> returnReply = {};
  Chat? replyMessage;
  // String name = '';
  // String message = '';
  // int? mID;
  // String? userName;
  // String? replyMessage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SocketService.setChatRoomId(
        widget.event.eID.toString()); // 使用 event 的 eid 作為聊天室ID
  }

  void cancelReply() {
    setState(() {
      // mID = 0;
      // userName = '';

      // replyMessage = '';
      replyMessage = null;
    });
  }

  // void updateData(Map<String, dynamic> data) {
  //   setState(() {
  //     returnReply = data;
  //     name = data['key2'];
  //     message = data['key1'];
  //   });
  // }

  void replyToMessage(Chat message) {
    setState(() {
      replyMessage = message;
    });
  }

  void _scrollDown() {
    try {
      Future.delayed(
          const Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: CloseButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
            backgroundColor: Color.fromRGBO(74, 125, 171, 1),
            centerTitle: true,
            title: Text(
              widget.event.eventName,
              style: TextStyle(color: Colors.black),
            )),
        // endDrawer: NavBar(),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/back.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MessagesWidget
                  _ChatBody(
                    onSwipedMessage: (message) {
                      replyToMessage(message);
                      focusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: 6),
                  // NewMessageWidget
                  ChatTextInput(
                    // key: chatTextInputKey,
                    chatRoomId: widget.event.eID.toString(),
                    // returnMessage: message,
                    // returnName: name,
                    focusNode: focusNode,
                    replyMessage: replyMessage,
                    onCancelReply: cancelReply,
                    event: widget.event, // 这里传递 Event 对象
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

// MessagesWidget
class _ChatBody extends StatefulWidget {
  final ValueChanged<Chat> onSwipedMessage;
  _ChatBody({Key? key, required this.onSwipedMessage}) : super(key: key);

  @override
  State<_ChatBody> createState() => __ChatBodyState();
}

class __ChatBodyState extends State<_ChatBody> {
  // Map<String, dynamic> returnReply = {};
  // String name = '';
  // String message = '';
  // late Chat replyMessage;

  @override
  void initState() {
    super.initState();
    // print(name);
    // print(message);
  }

  // void updateData(Map<String, dynamic> data) {
  //   setState(() {
  //     returnReply = data;
  //     name = data['key2'];
  //     message = data['key1'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var chats = <Chat>[];
    ScrollController _scrollController = ScrollController();

    ///scrolls to the bottom of page
    void _scrollDown() {
      try {
        Future.delayed(
            const Duration(milliseconds: 300),
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));
      } on Exception catch (_) {}
    }

    return Expanded(
      child: StreamBuilder(
        stream: SocketService.getResponse,
        builder: (BuildContext context, AsyncSnapshot<Chat> snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            chats.add(snapshot.data!);
          }
          _scrollDown();
          return ListView.builder(
            controller: _scrollController,
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final chat = chats[index];
              return SwipeTo(
                onRightSwipe: () => widget.onSwipedMessage(chat),
                child: MessageView(
                  chat: chat,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatTextInput extends StatefulWidget {
  final String chatRoomId;
  // final String? returnName;
  // final String? returnMessage;
  final FocusNode focusNode;
  final Chat? replyMessage;
  final VoidCallback onCancelReply;
  final Chat? chat;
  final Event event; // 添加此行

  ChatTextInput(
      {Key? key,
      required this.chatRoomId,
      // this.returnName,
      // this.returnMessage,
      required this.focusNode,
      this.replyMessage,
      required this.onCancelReply,
      required this.event, // 添加此行

      this.chat})
      : super(key: key);

  @override
  State<ChatTextInput> createState() => _ChatTextInputState();
}

class _ChatTextInputState extends State<ChatTextInput> {
  var textController = TextEditingController();
  String message = '';
  static final inputTopRadius = Radius.circular(12);
  static final inputBottomRadius = Radius.circular(24);
  //bool isReplying = false;

  // late String? name;
  // late String? message;

  // void updateNameAndMessage(String newName, String newMessage) {
  //   setState(() {
  //     name = newName;
  //     message = newMessage;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // isReplying = false;
    // setState(() {
    //   name = widget.returnName;
    //   message = widget.returnMessage;
    //   print(name);
    //   print(message);
    //   if (widget.returnMessage != null &&
    //       widget.returnName != null &&
    //       widget.returnMessage!.isNotEmpty &&
    //       widget.returnName!.isNotEmpty) {
    //     isReplying = true;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    final isReplying = widget.replyMessage != null;
    sendMessage() {
      FocusScope.of(context).unfocus();
      // widget.onCancelReply();
      var message = textController.text;
      if (message.isEmpty) return;
      SocketService.sendMessage(message, widget.replyMessage);
      textController.text = '';
      widget.focusNode.requestFocus();
    }

    void _pasteTextFromClipboard() async {
      ClipboardData? clipboardData =
          await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData != null) {
        String clipboardText = clipboardData.text ?? '';
        textController.text = clipboardText;
      }
    }

    // void showAddDialog() {
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container(
    //         height: 200,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             // Row(
    //             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             // children: [
    //             // Column(
    //             //   children: [
    //             //     IconButton(
    //             //       onPressed: () {
    //             //         widget.setReplyMessage('回复的消息内容'); // 设置回复消息
    //             //         Navigator.pop(context); // 关闭底部菜单
    //             //       },
    //             //       icon: Icon(Icons.photo_album),
    //             //       iconSize: 40,
    //             //     ),
    //             //     Text('相簿', style: TextStyle(fontSize: 16)),
    //             //   ],
    //             // ),
    //             // Column(
    //             //   children: [
    //             //     IconButton(
    //             //       onPressed: () {},
    //             //       icon: Icon(Icons.attach_money),
    //             //       iconSize: 40,
    //             //     ),
    //             //     Text('記帳', style: TextStyle(fontSize: 16)),
    //             //   ],
    //             // ),
    //             // Column(
    //             //   children: [
    //             //     IconButton(
    //             //       onPressed: () {},
    //             //       icon: Icon(Icons.location_on),
    //             //       iconSize: 40,
    //             //     ),
    //             //     Text('定位', style: TextStyle(fontSize: 16)),
    //             //   ],
    //             // ),
    //             // Column(
    //             //   children: [
    //             //     IconButton(
    //             //       onPressed: () {},
    //             //       icon: Icon(Icons.navigation),
    //             //       iconSize: 40,
    //             //     ),
    //             //     Text('導航', style: TextStyle(fontSize: 16)),
    //             //   ],
    //             // ),
    //             // ],
    //             // ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Column(
    //                   children: [
    //                     IconButton(
    //                       onPressed: () {},
    //                       icon: Icon(Icons.list),
    //                       iconSize: 40,
    //                     ),
    //                     Text('List', style: TextStyle(fontSize: 16)),
    //                   ],
    //                 ),
    //                 Column(
    //                   children: [
    //                     IconButton(
    //                       onPressed: () {},
    //                       icon: Icon(Icons.how_to_vote),
    //                       iconSize: 40,
    //                     ),
    //                     Text('投票', style: TextStyle(fontSize: 16)),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }
    void showAddDialog() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 100, // 調整高度以適合單一選項
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: Icon(Icons.poll),
                  title: Text('投票', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VotePage(event: widget.event), // 引導至投票頁面
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    Widget buildReply() => Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.only(
              topLeft: inputTopRadius,
              topRight: inputTopRadius,
            ),
          ),
          child: ReplyMessageWisget(
              chat: widget.chat!, onCancelReply: widget.onCancelReply),
        );

    return Container(
      margin: const EdgeInsets.all(12),
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddDialog,
          ),
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                _pasteTextFromClipboard();
              },
              child: Column(
                children: [
                  if (isReplying) buildReply(),
                  TextField(
                    maxLines: null,
                    focusNode: widget.focusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    autofocus: true,
                    controller: textController,
                    onSubmitted: (s) => sendMessage(),
                    decoration: InputDecoration(
                        hintText: 'Send a message',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: isReplying
                                  ? Radius.zero
                                  : Radius.circular(24),
                              topRight: isReplying
                                  ? Radius.zero
                                  : Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ))),
                    onChanged: (value) => setState(
                      () {
                        message = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              sendMessage();
            },
            child: const CircleAvatar(
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// class NavBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           SizedBox(height: 50),
//           ListTile(
//             leading: Icon(Icons.people),
//             title: Text('查看成員'),
//             onTap: () => null,
//           ),
//           ListTile(
//             leading: Icon(Icons.person_add),
//             title: Text('邀請成員'),
//             onTap: () => null,
//           ),
//           //Divider(),
//           ListTile(
//             leading: Icon(Icons.phone),
//             title: Text('通話'),
//             onTap: () => null,
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text('通知'),
//             onTap: () => null,
//           ),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text('設定'),
//             onTap: () => null,
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.exit_to_app),
//             title: Text('退出群組'),
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('確定是否退出群組', textAlign: TextAlign.center),
//                     content: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context); //關閉對話框
//                           },
//                           child: Text('是'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             // 處理"否"按钮的事件
//                             Navigator.pop(context); // 關閉對話框
//                           },
//                           child: Text('否'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
