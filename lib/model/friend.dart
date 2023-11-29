class Friend {
  final String name;
  String email; // 新增電子郵件欄位

  Friend(
    this.name,
    this.email,
  );

  factory Friend.fromName(String name) {
    return Friend(name, '');
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email, // 添加電子郵件到映射
    };
  }
}
