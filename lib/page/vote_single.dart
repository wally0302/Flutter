import 'package:create_event2/model/vote.dart'; // 请根据实际路径修改
import 'package:create_event2/page/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/vote_provider.dart';

class SingleVote extends StatefulWidget {
  final Vote vote;

  SingleVote({required this.vote});

  @override
  _SingleVoteState createState() => _SingleVoteState();
}

class _SingleVoteState extends State<SingleVote> {
  int selectedOptionIndex = -1;
  late List<int> optionVotes;

  @override
  void initState() {
    super.initState();
    optionVotes =
        List.from(widget.vote.optionVotes); // 使用widget.vote.optionVotes的初始值
  }

// 在vote函数中更新Vote对象
  void vote(int optionIndex) {
    final voteProvider = Provider.of<VoteProvider>(context, listen: false);

    setState(() {
      if (selectedOptionIndex != -1 && selectedOptionIndex != optionIndex)
        optionVotes[selectedOptionIndex]--;

      if (selectedOptionIndex == optionIndex) {
        selectedOptionIndex = -1;
      } else {
        selectedOptionIndex = optionIndex;
        optionVotes[optionIndex]++;
      }

      // 创建一个新的Vote对象来更新当前的投票状态
      final updatedVote = Vote(
        id: widget.vote.id,
        question: widget.vote.question,
        selectedDate: widget.vote.selectedDate,
        isMultipleChoice: widget.vote.isMultipleChoice,
        options: widget.vote.options,
        optionVotes: optionVotes,
      );

      // 使用Provider来更新Vote对象
      voteProvider.updateVote(updatedVote, widget.vote);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vote.options.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('投票'),
        ),
        body: Center(child: Text('没有可用的投票选项')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('投票結果', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        iconTheme: IconThemeData(color: Colors.black), // 將返回箭头设为黑色
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  widget.vote.question,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.vote.options.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      title: Text(
                        '${widget.vote.options[index]} (${optionVotes[index]})',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      value: index,
                      groupValue: selectedOptionIndex,
                      onChanged: (int? value) {
                        if (value != null) vote(value);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                    ),
                  ),
                  child: Text(
                    "投票", // 修改按钮文本为 "投票"
                    style: TextStyle(
                      color: Colors.black, // 设置文本颜色
                      fontSize: 15, // 设置字体大小
                      fontFamily: 'DFKai-SB', // 设置字体
                      fontWeight: FontWeight.w600, // 设置字体粗细
                    ),
                  ),
                  onPressed: () {
                    if (selectedOptionIndex != -1) {
                      // 进行额外的投票逻辑处理，例如更新数据库等。
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoteResult(
                          originalVote: widget.vote,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
