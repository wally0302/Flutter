import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? usernameError, emailError, passwordError, confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '註冊',
          style: TextStyle(
            fontSize: 30, // 調整字體大小
            fontFamily: 'DFKai-SB', // 設定字體
            fontWeight: FontWeight.w600, // 設定字體粗細
            color: Colors.black, // 設定字體顏色
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFCFE3F4), // 設定AppBar的背景顏色
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
          // Original Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(
                        _usernameController, '使用者名稱', usernameError),
                    SizedBox(height: 8),
                    _buildTextField(_emailController, '帳號 (電子郵件)', emailError),
                    SizedBox(height: 8),
                    _buildTextField(_passwordController, '密碼', passwordError,
                        isPassword: true),
                    SizedBox(height: 8),
                    _buildTextField(_confirmPasswordController, '確認密碼',
                        confirmPasswordError,
                        isPassword: true),
                    SizedBox(height: 16),
                    Container(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFCFE3F4), // 按鈕的背景顏色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // 按鈕的圓角
                          ),
                        ),
                        child: Text(
                          "註冊",
                          style: TextStyle(
                            color: Colors.black, // 文字顏色
                            fontSize: 20, // 文字大小
                            fontFamily: 'DFKai-SB', // 字體
                            fontWeight: FontWeight.w500, // 字體粗細
                          ),
                        ),
                        onPressed: _register, // 按下按鈕時執行的方法
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextField _buildTextField(
    TextEditingController controller,
    String label,
    String? error, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
      ),
      obscureText: isPassword,
    );
  }

  Future<void> _register() async {
    setState(() {
      usernameError = _usernameController.text.isEmpty ? '該欄位不能為空' : null;
      emailError = _emailController.text.isEmpty ? '該欄位不能為空' : null;
      passwordError = _passwordController.text.isEmpty ? '該欄位不能為空' : null;
      confirmPasswordError =
          _confirmPasswordController.text.isEmpty ? '該欄位不能為空' : null;

      if (_passwordController.text != _confirmPasswordController.text) {
        passwordError = '密碼不一致';
        confirmPasswordError = '密碼不一致';
      }
    });

    if (usernameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      return;
    }

    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user != null) {
        await user.user!.updateProfile(displayName: _usernameController.text);
        Navigator.pop(context); // Return to the login page after registration
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
