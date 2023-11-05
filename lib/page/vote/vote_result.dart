import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';

class VoteResult extends StatefulWidget {
  final Vote originalVote; // 将属性名称更改为originalVote，以避免与局部变量混淆

  VoteResult({required this.originalVote});

  @override
  State<VoteResult> createState() => _VoteResultState();
}

class _VoteResultState extends State<VoteResult> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VoteProvider>(
      builder: (context, voteProvider, child) {
        final vote = voteProvider.getVoteById(widget.originalVote.id);

        if (vote == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('投票结果'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/vote');
                  },
                ),
              ],
            ),
            body: Center(
              child: Text('投票结果未找到!'),
            ),
          );
        }

        // 计算总票数
        final totalVotes = vote.optionVotes.reduce((a, b) => a + b);

        return Scaffold(
          appBar: AppBar(
            title: const Text('投票結果', style: TextStyle(color: Colors.black)),
            centerTitle: true, //標題置中
            backgroundColor: Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
            iconTheme: IconThemeData(color: Colors.black), // 將返回箭头设为黑色

            actions: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/vote');
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '${vote.question}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vote.options.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            '${vote.options[index]}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '票数: ${vote.optionVotes[index]}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
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
      },
    );
  }
}
