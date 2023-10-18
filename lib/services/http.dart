import 'package:http/http.dart' as http;
import 'dart:convert';

class APIservice {
  ////////////////////// 行程(journey) //////////////////////
  // 新增行程 ok
  static Future<List<dynamic>> addJourney(
      {required Map<String, dynamic> content}) async {
    final url =
        Uri.parse("http://163.22.17.145:3000/api/journey/insertJourney");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }
  //查詢行程

  //刪除行程
  static Future<List<dynamic>> deleteJourney(
      {required Map<String, dynamic> content}) async {
    final url =
        Uri.parse("http://163.22.17.145:3000/api/journey/deteleJourney");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

// JourneyAPI.deleteJourney(jID: 123);
  static Future<List<dynamic>> deleteJourney1({required int jID}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/journey/$jID");

    final response = await http.delete(url);

    final responseString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return [true, responseString];
    } else {
      return [false, responseString];
    }
  }
  ////////////////////// 活動(event) //////////////////////

  //新增活動  OK
  static Future<List<dynamic>> addEvent(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/event/insertEvent");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  //活動列表的查詢活動 (需要回傳 eid)

  //刪除活動 透過 eid 刪除
  static Future<List<dynamic>> deleteEvent(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/event/deleteEvent/");
    // 刪除指定的 $uid : http://163.22.17.145:3000/api/event/deleteEvent/$eid
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }
}
