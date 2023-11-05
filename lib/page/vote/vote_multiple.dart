import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import '../../model/vote.dart'; // 别忘了导入你的 Vote 类

class VoteCheckbox extends StatefulWidget {
  final Vote vote;

  VoteCheckbox({
    required this.vote,
  });

  @override
  _VoteCheckboxState createState() => _VoteCheckboxState();
}

class _VoteCheckboxState extends State<VoteCheckbox> {
  List<bool> selectedOptions = []; // 存储每个选项是否被选中的列表
  List<int> optionVotes = []; // 存储每个选项的投票数量

  @override
  void initState() {
    super.initState();
    selectedOptions = List.filled(widget.vote.options.length, false);
    optionVotes = List.filled(widget.vote.options.length, 0); // 初始化投票数量为 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('投票'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.vote.question,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.vote.options.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  '${widget.vote.options[index]} (${optionVotes[index]})',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                value: selectedOptions[index],
                onChanged: (bool? value) {
                  setState(() {
                    selectedOptions[index] = value ?? false;

                    if (value ?? false) {
                      optionVotes[index]++;
                    } else {
                      optionVotes[index]--;
                    }
                  });
                },
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoteResult(
                        originalVote: widget.vote,
                      ), // 修改这里
                    ));
              },
              child: Text('投票'),
            ),
          ),
        ],
      ),
    );
  }
}
