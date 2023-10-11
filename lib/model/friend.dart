class Friend {
  final String name;
  bool isSelected;

  Friend(this.name, this.isSelected);
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
