import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:create_event2/page/userProfileEdit_page.dart';
import 'package:create_event2/page/help_page.dart';

class Setting_Page extends StatelessWidget {
  const Setting_Page({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 隱藏返回鍵

        title: const Text(
          '設置',
          style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        backgroundColor: Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"), // 確保圖片位於正確的路徑
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // buildItem('修改個人資訊', Icons.account_circle_outlined, () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => UserProfileEditPage()),
              //   );
              // }),
              // buildItem('連結Google帳號', Icons.link, () {
              //   // 實作功能
              // }),
              // buildItem('說明', Icons.help_outline, () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => HelpPage()),
              //   );
              // }),
              buildItem('登出', Icons.logout, () => _signOut(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(String text, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'DFKai-SB',
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
