// ignore_for_file: unused_import

import 'package:create_event2/model/journey.dart';
import 'package:create_event2/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../services/sqlite.dart';

//JourneyProvider 對象提供給應用程序的後代。
//這樣可以確保當 _journeys 列表發生變化時，與之相關的 UI 元素也會被更新，從而保持應用程序的一致性。

class JourneyProvider extends ChangeNotifier {
  final List<Journey> _journeys = []; //用來存放活動的List

  List<Journey> get journeys => _journeys; //取得活動的List

  DateTime _selectedDate = DateTime.now(); //選擇的日期預設為今天

  DateTime get selectedDate => _selectedDate; //取得選擇的日期

  void setDate(DateTime date) => _selectedDate = date; //設定選擇的日期

  List<Journey> get journeyOfSelectedDate => _journeys; //取得選擇日期的活動

  Future<void> fetchJourneysFromDatabase() async {
    final List<Map<String, dynamic>>? queryResult =
        await Sqlite.queryAll(tableName: 'journey');
    _journeys.clear();
    _journeys.addAll(queryResult!.map((e) => Journey.fromMap(e)));
    print('有拿到數據');
    notifyListeners();
  }

  // void addJourney(Journey journey) {
  //   _journeys.add(journey);
  //   notifyListeners(); //當 _journeys 列表發生變化時，它會通知所有的聽眾，以便更新與之相關的 UI 元素。
  // }

  void deleteJourney(Journey journey) {
    _journeys.remove(journey);
    notifyListeners();
  }

  void editJourney(Journey newJourney, Journey oldJourney) {
    final index = _journeys.indexOf(oldJourney);
    _journeys[index] = newJourney;
    notifyListeners();
  }

  List<Journey> searchJourneys(String keyword) {
    return _journeys
        .where((journey) =>
            journey.journeyName.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  List<Journey> getJourneys() {
    return List.from(_journeys);
  }

  void updateJourneys(List<Journey> updatedJourneys) {
    _journeys.clear();
    _journeys.addAll(updatedJourneys);
    notifyListeners();
  }
}
