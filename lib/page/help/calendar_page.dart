import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行事曆', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF4A7DAB),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
            ),
          ),
          // 在这里添加您的其他 widgets，例如文本或按钮
          Center(
            child: Text(
              '這是行事曆頁面',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
