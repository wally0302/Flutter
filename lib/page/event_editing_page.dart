// 新增活動頁面

// ignore_for_file: prefer_const_constructors

import 'package:create_event2/model/event.dart';
import 'package:create_event2/page/event_page.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:create_event2/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/page/event_viewing_page.dart';
// import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../model/friend.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;
  final bool? addTodayDate;
  final DateTime? time;

  const EventEditingPage({
    Key? key,
    this.event,
    this.addTodayDate,
    this.time,
  }) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();

  late DateTime fromDate; //匹配起始日
  late DateTime toDate; //匹配結束日
  late Color backgroundcolor = Colors.red;
  // 要讀取用戶輸入就需要 "TextEditingController"
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final remarkController = TextEditingController();

  late int selectedValue;
  bool enableNotification = false;
  bool inviteMembers = false;
  late DateTime BeginDate; // 活動預計開始時間

  late DateTime deadline; // 截止日期

  List<Friend> backendFriends = [
    Friend("Jack", false),
    Friend("Wiily", false),
    Friend("Julie", false),
    // Friend("好友二", false),
    // Friend("好友三", false),
  ];
  List<Friend> invitedFriends = [];

  late int selectedHours = 1; // 初始小時數為 1 小時
  late int selectedDuration = 0; // 初始時間長度為 60 分鐘

  void showFriendListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('選擇好友'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: backendFriends
                .where((friend) =>
                    !invitedFriends.contains(friend) && !friend.isSelected)
                .map((friend) {
              return ListTile(
                title: Text(friend.name),
                onTap: () {
                  setState(() {
                    friend.isSelected = true;
                    invitedFriends.add(friend);
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  ValueNotifier<int> reminderMinutes = ValueNotifier<int>(0);

  @override
  void initState() {
    // 初始化
    super.initState();

    // 新增活動
    if (widget.event == null) {
      fromDate = widget.time!;
      toDate = widget.time!;
      BeginDate = DateTime.now();
      backgroundcolor = Colors.red; //選擇顏色的地方
      deadline = DateTime.now();
      // 編輯活動
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
      backgroundcolor = Colors.red;
      deadline = event.deadline;
      BeginDate = event.BeginDate;
      invitedFriends = event.invitedFriends;
      selectedHours = event.selectedHour;
      selectedDuration = event.selectedMinute;
      if (!event.location.isNotEmpty) {
        locationController.text = '';
      } else {
        locationController.text = event.location;
      }
      if (!event.remark.isNotEmpty) {
        remarkController.text = '';
      } else {
        remarkController.text = event.remark;
      }
      reminderMinutes.value = event.notification;
      enableNotification = event.enableNotification;
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
        title: Text(widget.event == null ? '新增活動' : '編輯活動',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色

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
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
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
                  // buildIsAllDaySwitch(), //整天
                  buildDatePickers(), //匹配結束日
                  buildBeginTime(), //活動預計開始時間
                  // buildDateTimePickers(), //起始結束時間
                  buildHourMin(), //活動預計時間長度
                  // buildColorPicker(context), //背景顏色
                  buildLocation(), //地點
                  buildRemark(), //備註
                  buildInvitedMembersField(),
                  buildDeadlinePicker(),
                  showEnableNotification(), //提醒
                  if (enableNotification)
                    buildNotificationField(
                        text: '提醒時間 ：', onClicked: showReminderDialog),
                ],
              ),
            ),
          )),
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
            label: const Text(
              '儲存',
              style: TextStyle(color: Colors.black),
            )),
      ];

  //輸入完成儲存資料
  Future saveForm() async {
    final isvalid = _formKey.currentState!.validate();

    if (isvalid) {
      final event = Event(
        title: titleController.text,
        from: fromDate, //匹配起始日
        to: toDate,
        backgroundColor: backgroundcolor,
        location: locationController.text,
        description: 'description',
        remark: remarkController.text,
        notification: reminderMinutes.value,
        enableNotification: enableNotification,
        invitedFriends: invitedFriends,
        deadline: deadline,
        BeginDate: BeginDate, //活動預計開始時間
        selectedHour: selectedHours, //活動預計時間長度
        selectedMinute: selectedDuration,
      );
      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);
      } else {
        provider.addSortedEvent(event); // 使用 addSortedEvent
      }
      Navigator.pop(context); // 返回上一頁
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

  // // 建立選擇整天按鈕
  // Widget buildIsAllDaySwitch() => ListTile(
  //       title: Text('全天'),
  //       trailing: Switch(
  //         value: isAllday,
  //         onChanged: (value) => setState(() => isAllday = value),
  //       ),
  //     );

  // 建立匹配起始與結束日期
  Widget buildDatePickers() => Column(
        children: [
          buildFromDate(),
          buildToDate(),
        ],
      );
  Widget buildFromDate() {
    return buildHeader(
      header: '匹配起始日 ',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToDate() {
    return buildHeader(
      header: '匹配結束日 ',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(toDate),
              onClicked: () => pickToDateTime(pickDate: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBeginTime() {
    return buildHeader(
      header: '活動預計開始時間 ',
      child: Row(
        children: [
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(BeginDate),
              onClicked: () => pickBeginDate(pickDate: false),
            ),
          )
        ],
      ),
    );
  }

  // // 建立起始結束時間
  // Widget buildDateTimePickers() => Column(
  //       children: [
  //         buildFrom(),
  //         buildTo(),
  //       ],
  //     );

  // Widget buildFrom() {
  //   if (isAllday) {
  //     return buildHeader(
  //       header: '起始時間 ',
  //       child: buildDropdownField(
  //         text: Utils.toDate(fromDate),
  //         onClicked: () => pickFromDateTime(pickDate: true),
  //       ),
  //     );
  //   } else {
  //     return buildHeader(
  //       header: '起始時間 ',
  //       child: Row(
  //         children: [
  //           Expanded(
  //             flex: 2,
  //             child: buildDropdownField(
  //               text: Utils.toDate(fromDate),
  //               onClicked: () => pickFromDateTime(pickDate: true),
  //             ),
  //           ),
  //           Expanded(
  //             child: buildDropdownField(
  //               text: Utils.toTime(fromDate),
  //               onClicked: () => pickFromDateTime(pickDate: false),
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  // }

  // Widget buildTo() {
  //   if (isAllday) {
  //     return buildHeader(
  //       header: '結束時間 ',
  //       child: buildDropdownField(
  //         text: Utils.toDate(toDate),
  //         onClicked: () => pickToDateTime(pickDate: true),
  //       ),
  //     );
  //   } else {
  //     return buildHeader(
  //       header: '結束時間 ',
  //       child: Row(
  //         children: [
  //           Expanded(
  //             flex: 2,
  //             child: buildDropdownField(
  //               text: Utils.toDate(toDate),
  //               onClicked: () => pickToDateTime(pickDate: true),
  //             ),
  //           ),
  //           Expanded(
  //             child: buildDropdownField(
  //               text: Utils.toTime(toDate),
  //               onClicked: () => pickToDateTime(pickDate: false),
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  // }
  Widget buildHourMin() {
    return buildHeader(
      header: '活動預計時間長度 ',
      child: Row(
        children: [
          Container(
            width: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: TextEditingController(text: selectedHours.toString()),
              onChanged: (value) {
                setState(() {
                  selectedHours = int.tryParse(value) ?? selectedHours;
                });
              },
            ),
          ),
          const Text(' 小時'),
          const SizedBox(width: 16),
          Container(
            width: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller:
                  TextEditingController(text: selectedDuration.toString()),
              onChanged: (value) {
                setState(() {
                  selectedDuration = int.tryParse(value) ?? selectedDuration;
                });
              },
            ),
          ),
          const Text(' 分鐘'),
        ],
      ),
    );
  }

  // Widget buildColorPicker(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           Text(
  //             'Color ：',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           Container(
  //             decoration:
  //                 BoxDecoration(shape: BoxShape.circle, color: backgroundcolor),
  //             height: 30,
  //             width: 30,
  //           ),
  //         ],
  //       ),
  //       IconButton(
  //         //選擇顏色的按鈕
  //         icon: Icon(Icons.chevron_right_rounded),
  //         onPressed: () {
  //           showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlertDialog(
  //                 content: BlockPicker(
  //                   pickerColor: backgroundcolor,
  //                   onColorChanged: (color) {
  //                     setState(() {
  //                       backgroundcolor = color;
  //                     });
  //                   },
  //                 ),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('確認'),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         },
  //       )
  //     ],
  //   );
  // }

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
      fromDate = date;
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
  Widget buildInvitedMembersField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '參加好友 :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: invitedFriends.isEmpty
                  ? Text('未選擇好友')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: invitedFriends.map((friend) {
                        return Row(
                          children: [
                            Text(friend.name),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  invitedFriends.remove(friend);
                                  backendFriends
                                      .firstWhere((backendFriend) =>
                                          backendFriend.name == friend.name)
                                      .isSelected = false;
                                });
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                ),
              ),
              child: Text(
                "邀請",
                style: TextStyle(
                  color: Colors.black, // 设置文本颜色
                  fontSize: 15, // 设置字体大小
                  fontFamily: 'DFKai-SB', // 设置字体
                  fontWeight: FontWeight.w600, // 设置字体粗细
                ),
              ),
              onPressed: () {
                showFriendListDialog(); // 打开好友列表对话框
              },
            )
          ],
        ),
      ],
    );
  }

// 建立媒合開始時間
  Widget buildDeadlinePicker() {
    return buildHeader(
      header: '媒合開始時間 ',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(deadline),
              onClicked: () => pickDeadline(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(deadline),
              onClicked: () => pickDeadline(pickDate: false),
            ),
          )
        ],
      ),
    );
  }

// 選擇截止時間
  Future pickDeadline({required bool pickDate}) async {
    final date = await pickDateTime(deadline, pickDate: pickDate);

    if (date == null) return;

    setState(() {
      deadline = date;
    });
  }

  // 選擇截止時間
  Future pickBeginDate({required bool pickDate}) async {
    final date = await pickDateTime(BeginDate, pickDate: pickDate);

    if (date == null) return;

    setState(() {
      BeginDate = date;
    });
  }
}
