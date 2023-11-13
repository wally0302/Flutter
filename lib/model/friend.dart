class Friend {
  final String name;
  bool isSelected;

  Friend(this.name, [this.isSelected = false]);

  factory Friend.fromName(String name) {
    return Friend(name);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
