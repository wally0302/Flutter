import 'package:create_event2/page/vote/add_vote_page.dart';
import 'package:create_event2/page/vote/vote_multiple.dart';
import 'package:create_event2/page/vote/vote_single.dart';
import 'package:create_event2/provider/vote_provider.dart';
import 'package:create_event2/page/vote/voteList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';

class VotePage extends StatelessWidget {
  Future<void> _confirmDeleteDialog(BuildContext context, int index) async {
    final voteProvider = Provider.of<VoteProvider>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('確認刪除此投票？'),
          actions: <Widget>[
            TextButton(
              child: Text('是'),
              onPressed: () {
                voteProvider.deleteVote(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('否'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final voteProvider = Provider.of<VoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投票列表', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF4A7DAB),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/chat');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVotePage(),
                ),
              );

              if (result != null && result is Vote) {
                voteProvider.addVote(result);
              }
            },
          ),
        ],
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
          ListView.builder(
            itemCount: voteProvider.votes.length,
            itemBuilder: (context, index) {
              final vote = voteProvider.votes[index];

              return Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VoteList(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vote.question,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '截止時間 : ${DateFormat('yyyy/MM/dd HH:mm').format(vote.selectedDate)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30), // 设置按钮的圆角
                              ),
                            ),
                            child: Text(
                              "投票",
                              style: TextStyle(
                                color: Colors.black, // 设置文本颜色
                                fontSize: 15, // 设置字体大小
                                fontFamily: 'DFKai-SB', // 设置字体
                                fontWeight: FontWeight.w600, // 设置字体粗细
                              ),
                            ),
                            onPressed: () {
                              if (vote.isMultipleChoice) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VoteCheckbox(vote: vote),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SingleVote(vote: vote),
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _confirmDeleteDialog(context, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
