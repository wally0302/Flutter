// import 'package:flutter/material.dart';

// import '../../model/event.dart';
// import '../../services/socket_service.dart';
// import '../login_page.dart';
// import 'chat_page.dart';

// class ChatListView extends StatefulWidget {
//   final Event? event; // 將 event 定義為可空

//   const ChatListView({Key? key, this.event}) : super(key: key);

//   @override
//   State<ChatListView> createState() => _ChatListViewState();
// }

// class _ChatListViewState extends State<ChatListView> {
//   final String name = FirebaseEmail!;
//   final List<String> chatRooms = ["Chat Room 1", "Chat Room 2", "Chat Room 3"];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat Rooms")),
//       body: ListView.builder(
//         itemCount: chatRooms.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(chatRooms[index]),
//             onTap: () {
//               SocketService.setUserName(name);
//               SocketService.setChatRoomId(chatRooms[index]); // 設定聊天室 ID
//               SocketService.connectAndListen();
//               _navigateToNameInput(context, chatRooms[index]);
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _navigateToNameInput(BuildContext context, String chatRoomName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatPage(
//           chatRoomId: chatRoomName,
//         ),
//       ),
//     );
//   }
// }
