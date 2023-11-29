import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';

class VoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VoteProvider>(
      builder: (context, voteProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('投票結果', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Color(0xFF4A7DAB),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // 返回上一页面
              },
            ),
          ),
          body: ListView.builder(
            itemCount: voteProvider.votes.length,
            itemBuilder: (context, index) {
              final vote = voteProvider.votes[index];
              // final totalVotes =
              //     vote.optionVotes.reduce((a, b) => a + b); // 计算投票总数

              return ListTile(
                title: Text(
                  vote.voteName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text('投票總數: $totalVotes'), // 显示投票总数
                onTap: () {
                  // 处理点击事件，比如导航到投票详情页面
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //     VoteResult(
                  //       originalVote: vote, // 传递对应的 Vote 对象
                  //     ),
                  //   ),
                  // );
                },
              );
            },
          ),
        );
      },
    );
  }
}
