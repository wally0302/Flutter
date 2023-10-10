//"編輯" 和 "新增" 行程頁面

// ignore_for_file: prefer_const_constructors

import 'package:create_event2/model/journey.dart';
import 'package:create_event2/provider/journey_provider.dart';
import 'package:create_event2/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/page/journey_viewing_page.dart';
// import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../services/http.dart';

class JourneyEditingPage extends StatefulWidget {
  final Journey? journey;
  final bool? addTodayDate;
  final DateTime? time;

  const JourneyEditingPage({
    Key? key,
    this.journey,
    this.addTodayDate,
    this.time,
  }) : super(key: key);

  @override
  State<JourneyEditingPage> createState() => _JourneyEditingPageState();
}

class _JourneyEditingPageState extends State<JourneyEditingPage> {
  final _formKey = GlobalKey<FormState>();

  int jID = 0;
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  late Color backgroundcolor = Colors.black;
  final locationController = TextEditingController();
  final remarkController = TextEditingController();
  late int selectedValue;
  bool enableNotification = false;
  bool isAllday = false;

  ValueNotifier<int> reminderMinutes = ValueNotifier<int>(0);
  @override
  void initState() {
    //初始化
    super.initState();

    // 新增行程
    if (widget.journey == null) {
      jID = 0;

      if (widget.addTodayDate == false) {
        fromDate = widget.time!;
        toDate = fromDate.add(Duration(hours: 2));
        backgroundcolor = Colors.black;
      } else {
        fromDate = widget.time!;
        toDate = fromDate.add(Duration(hours: 2));
        backgroundcolor = Colors.black;
      }

      //如果傳入有 "journey" 就是 "編輯行程
    } else {
      // 編輯行程
      final journey = widget.journey!;

      titleController.text = journey.journeyName;
      fromDate = journey.journeyStartTime;
      toDate = journey.journeyEndTime;
      backgroundcolor = journey.color;

      if (!journey.location.isNotEmpty) {
        locationController.text = '';
      } else {
        locationController.text = journey.location;
      }
      if (!journey.remark.isNotEmpty) {
        remarkController.text = '';
      } else {
        remarkController.text = journey.remark;
      }
      reminderMinutes.value = journey.remindTime;
      enableNotification = journey.remindStatus;
      isAllday = journey.isAllDay;
    }
    selectedValue = reminderMinutes.value;
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.journey == null ? '新增行程' : '編輯行程',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFF4A7DAB),
        //左上 X 按鈕
        leading: CloseButton(
          color: Colors.black,
          onPressed: () {
            // 顯示提示框
            showDialogWidget();
          },
        ),
        //右上儲存按鈕
        actions: buildEditingActions(),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.png'),
                fit: BoxFit.cover, // 使用 BoxFit.cover 讓圖片覆蓋整個 Container
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildTitle(), //標題
                  const SizedBox(
                    height: 12,
                  ),
                  buildIsAllDaySwitch(), //整天
                  buildDateTimePickers(), //起始結束時間
                  buildColorPicker(context), //背景顏色
                  buildLocation(), //地點
                  buildRemark(), //備註
                  showEnableNotification(), //提醒
                  if (enableNotification)
                    buildNotificationField(
                        text: '提醒時間 ：', onClicked: showReminderDialog),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //提示框 (是否要取消編輯)
  void showDialogWidget() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          '提示',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const Text('取消編輯將不儲存\n是否要返回?'),
        actions: <CupertinoDialogAction>[
          //取消按鈕
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              //返回上一頁
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          //確認按鈕
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                // 返回到主畫面並移除其它route
                context,
                '/MyBottomBar2',
                ModalRoute.withName('/'),
              );
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }

  // 儲存按鈕
  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              // ignore: deprecated_member_use
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: saveForm, //儲存資料
            icon: const Icon(Icons.done, color: Colors.black),
            label: const Text('儲存', style: TextStyle(color: Colors.black))),
      ];

  //輸入完成儲存資料
  Future saveForm() async {
    final isvalid = _formKey.currentState!.validate();
    String uID = 'q';
    if (isvalid) {
      final journey = Journey(
          uID: uID,
          journeyName: titleController.text,
          location: locationController.text,
          journeyStartTime: fromDate,
          journeyEndTime: toDate,
          color: backgroundcolor,
          remark: remarkController.text,
          remindTime: reminderMinutes.value,
          remindStatus: enableNotification,
          isAllDay: isAllday);
      final isEditing = widget.journey != null;
      final provider = Provider.of<JourneyProvider>(context, listen: false);
      //編輯行程
      if (isEditing) {
        provider.editJourney(journey, widget.journey!);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                JourneyViewingPage(journey: journey), //回到行程詳細資料頁面
          ),
        );
        print('編輯成功');
        print(journey);
        //新增行程
      } else {
        provider.addJourney(journey);
        final result = await APIservice.addJourney(content: journey.toMap());
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/MyBottomBar2', //回到主頁面
          ModalRoute.withName('/'),
        );
      }
    }
  }

  // 建立標題
  Widget buildTitle() {
    return Row(
      children: [
        Text(
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
            onFieldSubmitted: (_) => {},
            validator: (title) => title != null && title.isEmpty
                //紅色警告
                ? 'Title can not be empty'
                : null,
            controller: titleController,
          ),
        ),
      ],
    );
  }

  // 建立選擇整天按鈕
  Widget buildIsAllDaySwitch() => ListTile(
        title: Text('全天'),
        trailing: Switch(
          value: isAllday,
          onChanged: (value) => setState(() => isAllday = value),
        ),
      );
  // 建立起始結束時間
  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() {
    if (isAllday) {
      return buildHeader(
        header: '起始時間 ',
        child: buildDropdownField(
          text: Utils.toDate(fromDate),
          onClicked: () => pickFromDateTime(pickDate: true),
        ),
      );
    } else {
      return buildHeader(
        header: '起始時間 ',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget buildTo() {
    if (isAllday) {
      return buildHeader(
        header: '結束時間 ',
        child: buildDropdownField(
          text: Utils.toDate(toDate),
          onClicked: () => pickToDateTime(pickDate: true),
        ),
      );
    } else {
      return buildHeader(
        header: '結束時間 ',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget buildColorPicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Color ：',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: backgroundcolor),
              height: 30,
              width: 30,
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.chevron_right_rounded),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: BlockPicker(
                    pickerColor: backgroundcolor,
                    onColorChanged: (color) {
                      setState(() {
                        backgroundcolor = color;
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('確認'),
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget buildLocation() {
    return Row(
      children: [
        Text(
          '地點 ：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextFormField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: '請輸入地點',
            ),
            onFieldSubmitted: (_) => {},
            controller: locationController,
          ),
        ),
      ],
    );
  }

  Widget buildRemark() {
    return Row(
      children: [
        Text(
          '備註 ：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextFormField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: '請輸入備註',
            ),
            onFieldSubmitted: (_) => {},
            controller: remarkController,
          ),
        ),
      ],
    );
  }

  Widget buildNotificationField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ValueListenableBuilder<int>(
        valueListenable: reminderMinutes,
        builder: (context, value, child) {
          return ListTile(
            title: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(width: 8),
                Icon(Icons.alarm),
                const SizedBox(width: 4),
                Text(value == 0 ? '時間到提醒' : '$value 分鐘'),
              ],
            ),
            trailing: Icon(Icons.chevron_right_rounded),
            onTap: onClicked,
          );
        },
      );

  Widget showEnableNotification() => ListTile(
        title: Text(
          '提醒：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: Switch(
          value: enableNotification,
          onChanged: (value) => setState(() => enableNotification = value),
        ),
      );

  Future<void> showReminderDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // int selectedValue = reminderMinutes.value; // 保存当前选中的值
            return AlertDialog(
              title: Text("提醒時間"),
              content: DropdownButton<int>(
                value: selectedValue,
                items: <int>[0, 5, 10, 15, 30, 60]
                    .map((int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value == 0 ? '時間到提醒' : '$value 分鐘'),
                        ))
                    .toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    reminderMinutes.value =
                        selectedValue; // 更新 ValueNotifier 的值
                    Navigator.of(context).pop();
                  },
                  child: const Text('確定'),
                ),
              ],
            );
          },
        );
      },
    );
  }

//確保使用者填寫時間是正確的
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return;
    // 起始時間 > 結束時間
    if (date.isAfter(toDate)) {
      // 年月日都一樣 判斷時間
      if (date.year == toDate.year &&
          date.month == toDate.month &&
          date.day == toDate.day) {
        // 起始小時>結束小時
        if (date.hour > toDate.hour) {
          // 結束小時+1
          toDate = DateTime(
              date.year, date.month, date.day, date.hour + 1, date.minute);
        }
        // 只有分鐘不同
        if (date.hour == toDate.hour) {
          if (date.minute > toDate.minute) {
            // 直接設跟起始一樣
            toDate = DateTime(
                date.year, date.month, date.day, date.hour, date.minute);
          }
        }
      } else {
        toDate = DateTime(
            date.year, date.month, date.day, toDate.hour, toDate.minute);
      }
    }
    setState(() {
      if (isAllday) {
        toDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);
        fromDate = DateTime(date.year, date.month, date.day, 0, 0);
      } else {
        fromDate = date;
      }
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );

    if (date == null) return;

    setState(() {
      //選擇整天
      if (isAllday) {
        toDate = DateTime(date.year, date.month, date.day, 0, 0);
        fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day, 0, 0);
      } else {
        if (date.isBefore(fromDate)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('警告'),
                content: Text('結束時間不能早於起始時間，\n請重新選擇結束時間'),
                actions: [
                  TextButton(
                    child: Text('確定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          toDate = date;
        }
      }
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
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
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );
  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$header：',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          child,
        ],
      );
}
