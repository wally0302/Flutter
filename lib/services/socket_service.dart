// ignore_for_file: avoid_print
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

import '../constants.dart';
import '../model/chat.dart';

class SocketService {
  static late StreamController<Chat> _socketResponse;
  static late StreamController<List<String>> _userResponse;
  static late io.Socket _socket;
  static String _userName = '';
  static String _chatRoomId = '';

  // static String? get userId => _socket.id;

  static Stream<Chat> get getResponse =>
      _socketResponse.stream.asBroadcastStream();
  static Stream<List<String>> get userResponse =>
      _userResponse.stream.asBroadcastStream();

  static void setUserName(String name) {
    _userName = name;
  }

  static void setChatRoomId(String chatRoomId) {
    _chatRoomId = chatRoomId;
  }

// 傳訊息給server
  static void sendMessage(String message, Chat? replyMessage) {
    _socket.emit('message', {
      "chatID": 1, //接收server 'eID': eid
      "userMall": _userName,
      "messageContent": message,
      "messageSendTime": DateTime.now().toString(),
    });
  }

  // 收回訊息
  static void returnMessage() {
    _socket.emit('returnMessage', {
      "userName": _userName,
      "returnMessage": 'true',
    });
  }

  // static void getChatMessages() {
  //   _socket.emit('getChatMessages', {"chatID": 1});
  // }

  static void connectAndListen() {
    //把這
    _socketResponse = StreamController<Chat>();
    _userResponse = StreamController<List<String>>();
    _socket = io.io(
        serverUrl,
        io.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM

            .setExtraHeaders({'foo': 'bar'})
            .disableAutoConnect()
            .setQuery({
              'userName': _userName,
              'chatRoomId': 1,
              'eID': 1
            }) //這個uid接收server  'eID': eid
            .build());

    _socket.connect();

    _socket.onConnectError((error) {
      print("Connection error: $error");
    });
    // 接收srver傳來的訊息
    //When an event recieved from server, data is added to the stream
    _socket.on('message', (data) {
      print('收到訊息');
      print(data);
      _socketResponse.sink.add(Chat.fromRawJson(data));
    });

    //接收server傳來的媒合不須投票結果
    _socket.on('result', (data) {
      _socketResponse.sink.add(Chat.fromRawJson(data));
    });

    // 接收一開始聊天室訊息
    _socket.on('chatMessage', (data) {
      print(data);
      // for (final element in data) {
      //   print(element);
      //   _socketResponse.sink.add(Chat.fromRawJson(element));
      // }
      _socketResponse.sink.add(Chat.fromRawJson(data));
      // data.forEach((element) {
      //   print(element);
      //   _socketResponse.sink.add(Chat.fromRawJson(element));
      // });
      print('印出一開始回復訊息');
      print(_socketResponse);
    });

    //接收server傳來的媒合須投票結果
    // _socket.on('resultVote', (data) {
    //   _socketResponse.sink.add(Chat.fromRawJson(data));
    // });

    //接收server傳來的收回訊息結果
    // _socket.on('returnMessage', (data) {
    //   // 使用 `StreamController` 來創建一個新的 `Stream`
    //   final streamController = StreamController<Chat>();
    //   // 將 `Chat` 資料添加到 `Stream` 中
    //   streamController.sink.add(Chat.fromRawJson(data));

    //   // 訂閱 `Stream`
    //   streamController.stream
    //       .where((chat) => chat.userId == data['userId'])
    //       .listen((chat) {
    //     // 更新資料
    //     chat.returnMessage = data['returnMessage'];

    //     // 將更新後的 `Chat` 資料添加到 `Stream` 中
    //     _socketResponse.sink.add(chat);
    //   });

    //   // 關閉 `StreamController`
    //   streamController.close();
    // });

    _socket.onConnect((_) {
      print('connect');
    });

    //when users are connected or disconnected
    _socket.on('users', (data) {
      var users = (data as List<dynamic>).map((e) => e.toString()).toList();
      _userResponse.sink.add(users);
    });

    _socket.onDisconnect((_) => print('disconnect'));
  }

  static void dispose() {
    _socket.dispose();
    _socket.destroy();
    _socket.close();
    _socket.disconnect();
    _socketResponse.close();
    _userResponse.close();
  }
}
