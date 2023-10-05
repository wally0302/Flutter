// import 'dart:io';
// import 'package:create_event2/model/event.dart';
// import 'package:create_event2/page/event_viewing_page.dart';
// ignore_for_file: prefer_const_constructors

import 'package:create_event2/page/chat_room_page.dart';
import 'package:create_event2/page/event_page.dart';
import 'package:create_event2/page/vote_page.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:create_event2/provider/journey_provider.dart';
import 'package:create_event2/provider/vote_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:create_event2/bottom_bar.dart';
import 'package:create_event2/page/login_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:go_router/go_router.dart'; // new
import 'package:provider/provider.dart'; // new
import 'app_state.dart'; // new

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]); //螢幕直立
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JourneyProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => VoteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const String title = '好揪不見';

  const MyApp({Key? key}) : super(key: key); // 修正 super() 的參數

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, //用來關閉右上角的debug標誌
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant'), // generic traditional Chinese 'zh_Hant'
        Locale('en', 'US'),
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW'), // 'zh_Hant_TW'
      ],
      locale: const Locale('zh'), //預設語言
      //路由
      routes: {
        '/MyBottomBar0': ((context) => const MyBottomBar(i: 0)),
        '/MyBottomBar1': ((context) => const MyBottomBar(i: 1)),
        '/MyBottomBar2': ((context) => const MyBottomBar(i: 2)),
        '/MyBottomBar3': ((context) => const MyBottomBar(i: 3)),
        '/MyBottomBar4': ((context) => const MyBottomBar(i: 4)),
        '/login': ((context) => LoginPage()),
        '/vote': ((context) => VotePage()),
        '/chat': ((context) => ChatRoomPage()),
        '/eventpage': ((context) => EventPage()),
      },
      title: title,
      themeMode: ThemeMode.light, // 顯示淺色主題
      darkTheme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: Colors.black), // 深色主題
      home: LoginPage(), // 預設頁面
    );
  }
}
