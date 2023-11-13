//左邊拉出來的選單
// ignore_for_file: camel_case_types, avoid_print

import 'package:create_event2/page/help_page.dart';
import 'package:create_event2/page/userProfileEdit_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'login_page.dart';

class Drawer_Page extends StatelessWidget {
  const Drawer_Page({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); //登出
      Get.off(LoginPage()); //返回登入頁面，不能返回上一頁
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color:
            Color(0xFFBFE1F4), // Set the color of the entire container to blue
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '揪 easy',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'Alice',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 48),
            buildItem('修改個人資訊', Icons.account_circle_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileEditPage()),
              );
            }),
            buildItem('連結Googlfe帳號', Icons.link, () {
              print('連結Google帳號');
            }),
            buildItem('說明', Icons.help_outline, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            }),
            buildItem('登出', Icons.logout, () => _signOut(context)),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: 'DFKai-SB',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
