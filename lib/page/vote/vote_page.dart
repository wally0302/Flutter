import 'package:create_event2/page/vote/add_vote_page.dart';
import 'package:create_event2/page/vote/vote_multiple.dart';
import 'package:create_event2/page/vote/vote_result.dart';
import 'package:create_event2/page/vote/vote_single.dart';
import 'package:create_event2/provider/vote_provider.dart';
import 'package:create_event2/page/vote/voteList.dart';
import 'package:create_event2/services/http.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../model/event.dart';
import '../../model/vote.dart';
import '../../services/sqlite.dart';
import '../login_page.dart';

class VotePage extends StatefulWidget {
  final Event? event;

  const VotePage({
    this.event,
    Key? key,
  }) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  TextEditingController questionController = TextEditingController();
  late DateTime endTime;
  bool isChecked = false;

  late List<dynamic> _votes = [];
  List<Vote> voteTest = [];

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now();
    getallVote();
  }

  // 抓投票資料表的資料
  getallVote() async {
    print('widget.event.eID');
    print(widget.event!.eID!); // 這裡要抓聊天室ID
    String voteName = questionController.text;
    Vote vote = Vote(
      vID: 1,
      eID: widget.event!.eID!,
      userMall: FirebaseEmail, // 這裡要根據使用者的userMall
      voteName: voteName,
      endTime: endTime,
      singleOrMultipleChoice: isChecked,
    );

    final result =
        await APIservice.seletallVote(eID: widget.event!.eID!); // 這裡要抓聊天室ID
    print('getallVote');
    print(result[1]);
    if (result[0]) {
      setState(() {
        // 將從數據庫中獲取的Map列表轉換為Vote對象列表
        _votes = result[1].map((map) => Vote.fromMap(map)).toList();
        print('抓取投票成功: $result');
      });
    } else {
      print('$result 在 server 抓取投票失敗');
    }
  }

  Future<void> _confirmDeleteDialog(
      BuildContext context, int index, Vote voteTest) async {
    // 11/20 更改--增加Vote voteTest
    final voteProvider = Provider.of<VoteProvider>(context, listen: false);

    // 返回一个对话框
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // 构建一个警告对话框
        return AlertDialog(
          title: Text('確認刪除此投票？'),
          actions: <Widget>[
            TextButton(
              child: Text('是'),
              onPressed: () async {
                // 调用API service删除投票和相关选项
                final List result = await APIservice.deleteVote(
                    vID: voteTest.vID); // 11/20 更改--可根據vid刪除投票
                final List result1 = await APIservice.deleteVoteOptions(
                    vID: voteTest.vID); // 11/20 更改--可根據vid刪除投票選項
                print(result[0]);
                if (result[0]) {
                  print('在server刪除投票成功');
                } else {
                  print('在server刪除投票失敗');
                }
                if (result1[0]) {
                  print('在server刪除投票選項成功');
                } else {
                  print('在server刪除投票選項失敗');
                }
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回上一页面
          },
        ),
        actions: <Widget>[
          IconButton(
            // 新增投票
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVotePage(
                    eID: widget.event!.eID!,
                  ),
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
            itemCount: _votes.length,
            itemBuilder: (context, index) {
              final vote = _votes[index];
              return Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  children: [
                    // 通过InkWell添加一个可点击的透明区域，用于导航到投票详情页
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
                          vote.voteName,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '截止時間 : ${DateFormat('yyyy/MM/dd HH:mm').format(vote.endTime)}',
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
                              DateTime.now().isBefore(vote.endTime)
                                  ? "投票"
                                  : "查看結果", // 時間到會將文字改成查看結果
                              style: TextStyle(
                                color: Colors.black, // 设置文本颜色
                                fontSize: 15, // 设置字体大小
                                fontFamily: 'DFKai-SB', // 设置字体
                                fontWeight: FontWeight.w600, // 设置字体粗细
                              ),
                            ),
                            onPressed: () {
                              // 根據投票的截止時間檢查是否可以進行投票
                              if (DateTime.now().isBefore(vote.endTime)) {
                                // 根据投票类型导航到不同的投票页面
                                if (vote.singleOrMultipleChoice) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // 多選
                                      builder: (context) => VoteCheckbox(
                                        vote: vote,
                                        // voteOptions:
                                        //     _voteOptions.cast<VoteOption>(),
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // 單選
                                      builder: (context) => SingleVote(
                                        vote: vote,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VoteResultPage(
                                              //結果頁面
                                              voteName: vote.voteName,
                                              vID: vote.vID,
                                            )));
                              }
                            },
                          ),
                          IconButton(
                            // 刪除投票
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _confirmDeleteDialog(
                                  context, index, vote); //11/20 更改
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
