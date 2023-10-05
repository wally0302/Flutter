//日期時間格式轉換
import 'package:intl/intl.dart';

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);
    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    // ignore: unnecessary_string_interpolations
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    // ignore: unnecessary_string_interpolations
    return '$time';
  }

  static String day(DateTime dateTime) {
    final year = DateFormat.y().format(dateTime);
    final month = DateFormat.M().format(dateTime);
    final date = DateFormat.d().format(dateTime);
    // ignore: unnecessary_string_interpolations
    return '$year/$month/$date';
  }
}
