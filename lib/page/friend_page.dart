import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

class Friend extends StatefulWidget {
  const Friend({Key? key}) : super(key: key);

  @override
  State<Friend> createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  final TextEditingController _searchController = TextEditingController();
  bool isTextCleared = false;
  List<String> filteredItems = [];
  List<String> nameList = [
    'Am',
    'Boms',
    'Moo',
    'Olgj',
    'Olir',
    'Cppte',
    'Dii',
    'Dk',
    'Ppte',
    'HOi',
    'k',
    'Kok',
  ];
  bool _showRequestDialog = false;
  String _requestContent = '';

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(nameList);
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    String keyword = _searchController.text;
    setState(() {
      filteredItems = nameList.where((item) => item.contains(keyword)).toList();
    });
  }

  void _deleteItem(String item) {
    setState(() {
      nameList.remove(item);
      filteredItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 隱藏返回鍵

        title: const Text(
          '好友',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4A7DAB),
        actions: [
          IconButton(
            icon: Icon(
              Icons.group_add,
              color: Colors.white,
            ),
            onPressed: () async {
              await _showAddFriendDialog(context);
            },
          ),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back.png'), // 背景图片
              fit: BoxFit.cover, // 填充模式
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _searchController,
                  onChanged: (text) {
                    setState(() {
                      isTextCleared = text.isNotEmpty;
                    });
                    _onSearchTextChanged();
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: isTextCleared
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                isTextCleared = false;
                              });
                              _onSearchTextChanged();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(),
                    hintText: 'Search Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black87,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      if (_showRequestDialog && index == 0) {
                        return Card(
                          color: Colors.lightBlueAccent,
                          child: ListTile(
                            title: Text(_requestContent),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  child: Text('確定'),
                                  onPressed: () {
                                    setState(() {
                                      nameList.add(_requestContent);
                                      filteredItems.insert(0, _requestContent);
                                      _showRequestDialog = false;
                                    });
                                  },
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  child: Text('取消'),
                                  onPressed: () {
                                    setState(() {
                                      _showRequestDialog = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          color: const Color(0xFFB0D7FD),
                          child: ListTile(
                            title: Text(filteredItems[index]),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await _showDeleteDialog(context, index);
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _showDeleteDialog(BuildContext context, int index) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('是否確認刪除'),
          actions: [
            ElevatedButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('刪除'),
              onPressed: () {
                _deleteItem(filteredItems[index]);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showAddFriendDialog(BuildContext context) async {
    String inputData = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('輸入好友帳號'),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: '請輸入帳號...',
                  ),
                  onChanged: (value) {
                    inputData = value;
                  },
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Share.share('複製文字');
              },
              icon: Icon(
                Icons.share,
                color: Colors.purpleAccent,
              ),
            ),
            ElevatedButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(inputData);
              },
            ),
            ElevatedButton(
              child: Text('加好友'),
              onPressed: () {
                if (nameList.contains(inputData)) {
                  _showFriendExistsDialog(context);
                } else {
                  setState(() {
                    _showRequestDialog = true;
                    _requestContent = inputData;
                  });
                  Navigator.of(context).pop(inputData);
                }
              },
            ),
          ],
        );
      },
    );
  }

  _showFriendExistsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('好友已存在'),
          content: Text('該好友已在您的好友名單中'),
          actions: [
            ElevatedButton(
              child: Text('確定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
