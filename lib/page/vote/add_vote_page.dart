import 'package:create_event2/page/login_page.dart';
import 'package:create_event2/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';
import '../../services/http.dart';

class AddVotePage extends StatefulWidget {
  final Vote? vote;
  final int? eID;
  const AddVotePage({
    this.eID,
    Key? key,
    this.vote,
  });
  @override
  _AddVotePageState createState() => _AddVotePageState();
}

class _AddVotePageState extends State<AddVotePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController questionController = TextEditingController();
  late DateTime endTime;
  bool isChecked = false;
  List<String> options = ['']; //選項
  List<int> optionVotes = []; // 票數

  // 添加选项的函数
  void addOption() {
    // 更新状态，添加一个空字符串到选项列表
    setState(() {
      options.add('');
      print(options);
    });
  }

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增投票', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: const Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // 返回上一个页面
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildTitle(), // 构建标题部分的方法
            const SizedBox(height: 16.0),
            buildOptions(), // 构建选项部分的方法
            const SizedBox(height: 16.0),
            buildButtonAdd(), // 构建“添加”按钮部分的方法
            const SizedBox(height: 16.0),
            buildDateTimePickers(), // 构建日期时间选择器部分的方法
            const SizedBox(height: 16.0),
            buildCheckBox(), // 构建复选框部分的方法
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFCFE3F4), // 设置按钮的背景颜色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                ),
              ),
              child: Text(
                "送出投票",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // 设置文本颜色
                  fontSize: 15, // 设置字体大小
                  fontFamily: 'DFKai-SB', // 设置字体
                  fontWeight: FontWeight.w600, // 设置字体粗细
                ),
              ),
              onPressed: saveForm,
            )
          ],
        )),
      ),
    );
  }

  //建立標題
  Widget buildTitle() {
    return Row(
      children: [
        const Text(
          '名稱 ：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextFormField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: '請輸入標題',
            ),
            onFieldSubmitted: (_) => {}, // 当用户提交表单字段时的回调函数
            validator: (title) =>
                title != null && title.isEmpty // 标题不能为空的验证错误消息
                    ? 'Title can not be empty'
                    : null,
            controller: questionController, // 与文本输入框控制器关联的控制器
          ),
        ),
      ],
    );
  }

  //建立投票選項
  Widget buildOptions() {
    return Column(
      children: [
        const Text(
          '投票選項 :',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          children: options.asMap().entries.map((entry) {
            int index = entry.key;
            return Row(
              children: [
                Expanded(
                    child: TextFormField(
                  onChanged: (value) {
                    // 当文本字段变化时更新选项列表中的值
                    options[index] = value;
                  },
                  decoration: InputDecoration(
                    labelText: '選項 ${index + 1}', // 显示选项标签
                  ),
                )),
                IconButton(
                  onPressed: () {
                    setState(() {
                      options.removeAt(index); //点击按钮时移除相应索引的选项
                    });
                  },
                  icon: const Icon(Icons.cancel), // 显示取消图标的按钮
                )
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildButtonAdd() {
    return ElevatedButton(
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
    );
  }

  // 建立是否多選的選項
  Widget buildCheckBox() {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('一人多選'),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
          ),
        )
      ],
    );
  }

  // 建立結束時間
  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
        ],
      );
  Widget buildFrom() {
    return buildHeader(
      header: '截止時間',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(endTime),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(endTime),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          )
        ],
      ),
    );
  }

// 下拉字段的通用构建方法
  Widget buildDropdownField({
    required String text, // 显示在列表标题上的文本
    required VoidCallback onClicked, // 点击时触发的回调函数
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down), // 下拉箭头图标
        onTap: onClicked, // 点击时触发的回调函数
      );
  // 带标题的通用构建方法
  Widget buildHeader({
    required String header, // 显示的标题文本
    required Widget child, // 子部件
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$header：', // 在标题前添加冒号的标题文本
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20), // 设置标题的样式
          ),
          child, // 显示子部件
        ],
      );
// 异步方法，用于选择日期和时间
  Future pickFromDateTime({required bool pickDate}) async {
    final date =
        await pickDateTime(endTime, pickDate: pickDate); // 调用选择日期和时间的方法

    if (date == null) return;
    // 起始時間 > 結束時間
    if (date.isAfter(endTime)) {
      // 年月日都一樣 判斷時間
      if (date.year == endTime.year &&
          date.month == endTime.month &&
          date.day == endTime.day) {
        // 起始小時>結束小時
        if (date.hour > endTime.hour) {
          // 結束小時+1
          endTime = DateTime(
              date.year, date.month, date.day, date.hour + 1, date.minute);
        }
        // 只有分鐘不同
        if (date.hour == endTime.hour) {
          if (date.minute > endTime.minute) {
            // 直接設跟起始一樣
            endTime = DateTime(
                date.year, date.month, date.day, date.hour, date.minute);
          }
        }
      } else {
        endTime = DateTime(
            // 更新结束时间为选择的时间
            date.year,
            date.month,
            date.day,
            endTime.hour,
            endTime.minute);
      }
      setState(() {
        endTime = date;
      });
    }
  }

// 异步方法，用于选择日期和时间
  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate, // 是否选择日期
    DateTime? firstDate, // 可选的最早日期
  }) async {
    if (pickDate) {
      // 显示日期选择器
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;
      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );
      return date.add(time); // 返回选择的日期和保留的时间
    } else {
      // 显示时间选择器
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;
      // 保留初始日期的年、月、日
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time); // 返回选择的时间和保留的日期
    }
  }

  // 儲存
  Future saveForm() async {
    // 獲取投票名稱
    String voteName = questionController.text;
    // 检查投票名称是否非空
    if (voteName.isNotEmpty) {
      // 从选项列表中过滤出非空选项
      List<String> updatedOptions =
          options.where((option) => option.isNotEmpty).toList();
      // 检查是否存在非空选项
      if (updatedOptions.isNotEmpty) {
        // 生成一个包含所有选项初始投票数（均为0）的列表
        List<int> initialOptionVotes =
            List.generate(updatedOptions.length, (index) => 0);
        // 創建一個代表整體投票的Vote對象
        Vote vote = Vote(
          vID: 1,
          eID: widget.eID, //這裡要改聊天室ID
          userMall: FirebaseEmail,
          voteName: voteName,
          endTime: endTime,
          singleOrMultipleChoice: isChecked,
        );
        // 使用API service將整體的投票添加到數據庫
        final result =
            await APIservice.addVote(content: vote.toMap()); // 新增投票進資料庫
        // 獲取從後端傳回來的vID
        int newVID = result[1]['vID'];
        // 創建一個包含所有選項信息的VoteOption對象
        VoteOption voteOption = VoteOption(
          oID: 1,
          vID: newVID,
          votingOptionContent: options,
          // optionVotes: optionVotes
        );
        // 遍歷每個選項並創建一個獨立的VoteOption對象
        for (var element in options) {
          VoteOption voteOptiontest = VoteOption(
            oID: 1,
            vID: newVID,
            votingOptionContent: [element], //a
            // optionVotes: optionVotes
          );

          // 使用API service將單獨的選項添加到數據庫
          final result1 = await APIservice.addVoteOptions(
              content: voteOptiontest.toMap()); // 新增投票選項進資料庫
        }
        // 獲取新創建投票的所有選項
        final allOptionResult =
            await APIservice.seletallVoteOptions(vID: newVID);
        // 遍歷所有選項，創建VoteResult對象，表示投票結果
        for (int i = 0; i < allOptionResult[1].length; i++) {
          VoteResult voteResult = VoteResult(
            voteResultID: 1,
            vID: newVID,
            userMall: '1112', // 這裡要改根據使用者的userMall
            oID: allOptionResult[1][i]["oID"],
            status: false, // 預設為0
          );
          // 使用API service將VoteResult對象添加到數據庫
          final result2 =
              await APIservice.addVoteResult(content: voteResult.toMap());
        }

        // 将整体的选项添加到Provider中
        Provider.of<VoteProvider>(context, listen: false)
            .addVoteOptions(voteOption);
        // 将整体的投票添加到Provider中
        Provider.of<VoteProvider>(context, listen: false).addVote(vote);
        Navigator.pop(context);
      }
    }
  }
}
