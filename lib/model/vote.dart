import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Vote {
  final String id; // 新增的id属性
  final String question;
  final DateTime selectedDate;
  final bool isMultipleChoice;
  final List<String> options;
  final List<int> optionVotes;

  // 构造函数，用于初始化对象
  Vote({
    required this.id, // 新增的id参数
    required this.question,
    required this.selectedDate,
    required this.isMultipleChoice,
    required this.options,
    required this.optionVotes,
  });

  // 你可以使用下面的工厂构造函数来创建Vote对象，并自动生成id
  factory Vote.create({
    required String question,
    required DateTime selectedDate,
    required bool isMultipleChoice,
    required List<String> options,
    required List<int> optionVotes,
  }) {
    final id = Uuid().v4(); // 使用uuid库生成一个唯一的id
    return Vote(
      id: id,
      question: question,
      selectedDate: selectedDate,
      isMultipleChoice: isMultipleChoice,
      options: options,
      optionVotes: optionVotes,
    );
  }

  // 您需要根据实际情况调整下面的方法

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Vote) return false;

    return other.id == id && // 比较id属性
        other.question == question &&
        other.selectedDate == selectedDate &&
        other.isMultipleChoice == isMultipleChoice &&
        listEquals(other.options, options) &&
        listEquals(other.optionVotes, optionVotes);
  }

  @override
  int get hashCode {
    return id.hashCode ^ // 包含id属性
        question.hashCode ^
        selectedDate.hashCode ^
        isMultipleChoice.hashCode ^
        options.hashCode ^
        optionVotes.hashCode;
  }
}
