// ignore_for_file: prefer_const_constructors

import 'package:create_event2/page/event_page.dart';
import 'package:create_event2/page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:create_event2/main.dart';

import 'package:create_event2/page/journey_editing_page.dart';
import 'package:create_event2/page/search_page.dart';
import 'package:create_event2/page/event_editing_page.dart';
import 'package:create_event2/page/friend_page.dart';

class MyBottomBar extends StatefulWidget {
  final int i; // 點選哪個buttom

  const MyBottomBar({
    Key? key,
    required this.i,
  }) : super(key: key);

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 2; // 預設值
  bool _showBottomNavBar = true; //底部導覽欄是否顯示

  final List<Widget> _screens = [
    EventPage(), //0
    //沒有傳 journey 的話，就是"新增"行程頁面
    JourneyEditingPage(
      addTodayDate: false,
      time: DateTime.now(),
    ), //1
    MainPage(), //2
    SearchPage(), //3
    Friend() //4
  ];
  // 點選buttom
  void _onItemTapped(int idx) {
    setState(() {
      _selectedIndex = idx;

      _showBottomNavBar = (_selectedIndex != 1); //除了新增行程頁面，其他都顯示底部導覽欄
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.i; // 設初始值
    _showBottomNavBar = (_selectedIndex != 1); // 根據初始值設 _showBottomNavBar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _showBottomNavBar
          ? Container(
              height: 70, // 修改這裡可以改變 BottomBar 的高度
              color: Color(0xFF4A7DAB),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem('活動', 0, 'assets/images/calendar.png'),
                  _buildNavItem('行程', 1, 'assets/images/plus.png'),
                  _buildNavItem('主畫面', 2, 'assets/images/home.png'),
                  _buildNavItem('搜尋', 3, 'assets/images/search.png'),
                  _buildNavItem('好友', 4, 'assets/images/users.png'),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildNavItem(String label, int index, String imagePath) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 30, // 這裡可以設置圖標的大小
            height: 30, // 這裡可以設置圖標的大小
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14, // 這裡可以設置字體的大小
              fontFamily: 'DFKai-SB',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
