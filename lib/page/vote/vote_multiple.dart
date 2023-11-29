import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';
import '../../services/http.dart'; // 别忘了导入你的 Vote 类

class VoteCheckbox extends StatefulWidget {
  final Vote vote;

  VoteCheckbox({
    Key? key,
    required this.vote,
  }) : super(key: key);

  @override
  _VoteCheckboxState createState() => _VoteCheckboxState();
}

class _VoteCheckboxState extends State<VoteCheckbox> {
  late List<bool> selectedOptionIndex = []; // 儲存每個選項是否被選中

  late List<dynamic> _voteOptions = [];

  @override
  void initState() {
    super.initState();
    getOption(); // 抓回選項內容
    getallResults(); // 抓回投票結果頁面
  }

  // 抓回選項內容
  getOption() async {
    // 調用API服務，獲取投票選項
    final result = await APIservice.seletallVoteOptions(vID: widget.vote.vID);
    if (result[0]) {
      // 如果成功，更新狀態並將投票選項映射為對應的對象列表
      setState(() {
        _voteOptions = result[1].map((map) => VoteOption.fromMap(map)).toList();
        // 根據投票選項的數量動態生成 selectedOptionIndex 列表，並初始化為 false
        selectedOptionIndex =
            List.generate(_voteOptions.length, (index) => false);
      });
    } else {
      print('$result 在 server 抓取投票選項失敗');
    }
  }

  // 抓回投票結果頁面
  getallResults() async {
    // 從伺服器獲取投票結果
    final result = await APIservice.seletallVoteResult(
        vID: widget.vote.vID, userMall: '1112'); // userMall要更改
    print('伺服器返回的結果: $result');

    // 檢查伺服器回傳的結果是否是一個 List
    if (result is List) {
      if (result.length >= 2 &&
          result[1] is List &&
          result[1].isNotEmpty &&
          result[1][0] is Map) {
        // 根據投票選項的數量動態生成 selectedOptionIndex 列表，並初始化為 false
        setState(() {
          selectedOptionIndex =
              List.generate(_voteOptions.length, (index) => false);
        });
        // 遍歷伺服器返回的投票結果
        for (int i = 0; i < result[1].length; i++) {
          // 檢查投票結果中 'status' 是否為 1
          if (result[1][i]['status'] == 1) {
            // 從伺服器返回的投票結果中獲取 oID
            int oIDFromServer = result[1][i]['oID'];

            // 在投票選項中查找與伺服器返回的 oID 相符的索引
            int indexInOptions = _voteOptions
                .indexWhere((option) => option.oID == oIDFromServer);
            // 如果找到相符的索引，則將對應的 selectedOptionIndex 設置為 true
            if (indexInOptions != -1) {
              selectedOptionIndex[indexInOptions] = true;
            }
          }
        }
        print('抓投票結果成功: $selectedOptionIndex');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投票', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: const Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        iconTheme: const IconThemeData(color: Colors.black), // 將返回箭头设为黑色
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.vote.voteName,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _voteOptions.length,
              itemBuilder: (context, index) {
                String optionText =
                    _voteOptions[index].votingOptionContent.join(", ");
                return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      optionText,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    value: selectedOptionIndex[index],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedOptionIndex[index] = value!;
                      });
                    });
              }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                  ),
                ),
                child: const Text(
                  '投票',
                  style: TextStyle(
                    color: Colors.black, // 设置文本颜色
                    fontSize: 15, // 设置字体大小
                    fontFamily: 'DFKai-SB', // 设置字体
                    fontWeight: FontWeight.w600, // 设置字体粗细
                  ),
                ),
                onPressed: () async {
                  String tmpUserMail = '1112'; //這裡要更改為根據使用者的userMall
                  final tmpResult = await APIservice.seletallVoteResult(
                      vID: widget.vote.vID, userMall: tmpUserMail);
                  // 存儲更新後的投票結果內容
                  List<Map<String, dynamic>> contents = [];
                  // 遍歷所有投票選項
                  for (int i = 0; i < _voteOptions.length; i++) {
                    // 從投票結果中獲取當前選項的 oID
                    int curremtOID = tmpResult[1][i]["oID"];
                    // 檢查當前選項是否被選中
                    bool isSelected = selectedOptionIndex[i];
                    // 創建包含投票結果相關信息的 Map
                    Map<String, dynamic> content = {
                      'vID': widget.vote.vID,
                      'oID': curremtOID,
                      'userMall': tmpUserMail,
                      'status': isSelected ? 1 : 0,
                    };

                    contents.add(content); // 添加到 contents 列表中

                    print('Content $i: $content');
                    // 遍歷 contents 列表，向伺服器更新每個投票結果
                    for (int i = 0; i < contents.length; i++) {
                      // 向伺服器發送更新投票結果的請求
                      final result = await APIservice.updateResult(
                          content: contents[i],
                          voteResultID: tmpResult[1][i]["voteResultID"]);
                      // 從投票結果中獲取當前選項的 oID
                      int tmpOid = tmpResult[1][i]["oID"];
                      if (result[0]) {
                        print('更改$tmpOid結果成功');
                      } else {
                        print('更改$tmpOid結果失敗');
                      }
                    }
                  }
                  // 導航到投票結果頁面
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoteResultPage(
                        voteName: widget.vote.voteName,
                        vID: widget.vote.vID,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
