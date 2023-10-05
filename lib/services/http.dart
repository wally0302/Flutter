import 'dart:convert';
import 'package:http/http.dart' as http;

class APIservice {
  static Future<List> addJourney(
      {required Map<String, dynamic> content}) async {
    String url = "http://163.22.17.145:3000/api/event/add_event"; //api後接檔案名稱
    final response = await http.post(Uri.parse(url),
        body: content.toString()); // 根據使用者的token新增資料
    try {
      final responseString = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        print('server新增行程成功');
        return [true, responseString];
      } else {
        print(responseString);
        return [false, responseString];
      }
    } catch (e) {
      print(e.toString());
      return [false, e.toString()];
    }
  }
}
