import 'package:sqflite/sqflite.dart';

class Sqlite {
  static const sqlFileName = 'calendar.db';
  static const dbVersion = 1;
  static const userTable = 'user';
  static const friendTable = 'friend';
  static const journeyTable = 'journey';
  static const eventTable = 'event';

  static Database? db;
  static Future<Database?> get open async => db ??= await initDatabase();

  static Future<Database?> initDatabase() async {
    print('初始化資料庫');
    String path =
        "${await getDatabasesPath()}/$sqlFileName"; // 這是 Future 的資料，前面要加 await
    print('DB PATH $path');

    db = await openDatabase(path, version: dbVersion, onCreate: _onCreate);
    print('DB DB $db');
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    // 會員
    await db.execute('''
        CREATE TABLE $userTable (
        uID text,
        userName text,
        );
      ''');
    print('建立使用者資料表');
    await db.execute('''
        CREATE TABLE $friendTable (
        fID integer primary key AUTOINCREMENT,
        uID integer,
        account text,
        name text
        );
      ''');
    print('建立好友資料表');
    // 行程
    await db.execute('''
        CREATE TABLE $journeyTable (
        jID text,
        uID text,
        journeyName text,
        journeyStartTime text,
        journeyEndTime text,
        location text,
        remindTime text,
        remark text,
        );
      ''');
    print('建立行程資料表');
    // 活動
    await db.execute('''
        CREATE TABLE $eventTable (
        eID text,
        uID text,
        eventName text,
        event_First_Start_Time text,
        event_First_End_Time text,
        event_Final_Start_Time text,
        event_Final_Start_Time text,
        state text,
        matchmaking_End_Time text,
        location text,
        remindTime text,
        remark text,
        inviteLink text,
        );
      ''');
    print('建立活動資料表');
  }
}
