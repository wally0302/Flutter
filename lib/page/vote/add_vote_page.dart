// add_vote_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';

class AddVotePage extends StatefulWidget {
  @override
  _AddVotePageState createState() => _AddVotePageState();
}

class _AddVotePageState extends State<AddVotePage> {
  TextEditingController questionController = TextEditingController();
  List<String> options = [''];
  DateTime _dateTime = DateTime.now();
  String _endTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  bool isChecked = false;

  void addOption() {
    setState(() {
      options.add('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增投票', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // 返回上一个页面
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
            ),
          ),

          ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  labelText: '問題描述',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '投票選項',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Column(
                children: options.asMap().entries.map((entry) {
                  int index = entry.key;
                  return TextFormField(
                    onChanged: (value) {
                      options[index] = value;
                    },
                    decoration: InputDecoration(
                      labelText: '選項 ${index + 1}',
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                  ),
                ),
                child: Text(
                  "新增選項",
                  style: TextStyle(
                    color: Colors.black, // 设置文本颜色
                    fontSize: 15, // 设置字体大小
                    fontFamily: 'DFKai-SB', // 设置字体
                    fontWeight: FontWeight.w600, // 设置字体粗细
                  ),
                ),
                onPressed: addOption,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: '截止日期',
                        hintText:
                            '${_dateTime.year}/${_dateTime.month}/${_dateTime.day}',
                        suffixIcon: IconButton(
                          onPressed: _getDate,
                          icon: Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: _endTime,
                        suffixIcon: IconButton(
                          onPressed: () async {
                            _getTime(isStartTime: true);
                          },
                          icon: Icon(Icons.access_time_rounded),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('一人多選'),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                  ),
                ),
                child: Text(
                  "送出投票",
                  style: TextStyle(
                    color: Colors.black, // 设置文本颜色
                    fontSize: 15, // 设置字体大小
                    fontFamily: 'DFKai-SB', // 设置字体
                    fontWeight: FontWeight.w600, // 设置字体粗细
                  ),
                ),
                onPressed: () {
                  String question = questionController.text;
                  if (question.isNotEmpty) {
                    List<String> updatedOptions =
                        options.where((option) => option.isNotEmpty).toList();

                    if (updatedOptions.isNotEmpty) {
                      List<int> initialOptionVotes =
                          List.generate(updatedOptions.length, (index) => 0);

                      Vote newVote = Vote.create(
                        question: question,
                        options: updatedOptions,
                        selectedDate: _dateTime,
                        isMultipleChoice: isChecked,
                        optionVotes: initialOptionVotes,
                      );

                      Provider.of<VoteProvider>(context, listen: false)
                          .addVote(newVote);
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _getDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (date != null && date != _dateTime) {
      setState(() {
        _dateTime = date;
      });
    }
  }

  Future<void> _getTime({required bool isStartTime}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime tempDateTime = DateTime(_dateTime.year, _dateTime.month,
          _dateTime.day, pickedTime.hour, pickedTime.minute);
      setState(() {
        if (isStartTime) _endTime = DateFormat('hh:mm a').format(tempDateTime);
      });
    }
  }
}
