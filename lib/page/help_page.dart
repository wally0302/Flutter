import 'package:flutter/material.dart';

import 'help/calendar_page.dart';
import 'help/user_profile_page.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('說明', style: TextStyle(color: Colors.black)),
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
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFBFE1F4), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "針對使用者需求、疑惑提供說明，使用者可自行選擇問題相關類型，點及該類型選項後將會有幾項常見問題說明，對使用者提供幫助。",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                buildButtonWithImage(
                  context,
                  '個人資料',
                  'assets/images/curly.png',
                  () {
                    // Navigate to the new page when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfilePage(), // Replace with your page
                      ),
                    );
                  },
                ),
                buildButtonWithImage(
                  context,
                  '行事曆',
                  'assets/images/calendar.png',
                  () {
                    // Navigate to the new page when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CalendarPage(), // Replace with your page
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonWithImage(BuildContext context, String text,
      String imagePath, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xCCA2D5F2), // Button color
          onPrimary: Colors.black, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 30, height: 30),
            SizedBox(width: 10),
            Text(text, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
