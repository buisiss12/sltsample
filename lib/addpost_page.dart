import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  AddPostPageState createState() => AddPostPageState();
}

class AddPostPageState extends State<AddPostPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _postText = TextEditingController();
  final List<String> _selectedArea = [];
  final List<String> _japanArea = [
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県',
  ];

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _postText.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _postText.removeListener(_updateButtonState);
    _postText.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (_postText.text.isNotEmpty && _selectedArea.isNotEmpty) {
      if (!isButtonEnabled) {
        setState(() {
          isButtonEnabled = true;
        });
      }
    } else {
      if (isButtonEnabled) {
        setState(() {
          isButtonEnabled = false;
        });
      }
    }
  }

  void _addPost() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userData = await _firestore.collection('users').doc(user.uid).get();
      var age = userData['生年月日'];
      var nickname = userData['ニックネーム'];

      await _firestore.collection('posts').add({
        '募集内容': _postText.text,
        '希望地域': _selectedArea,
        'UID': user.uid,
        '生年月日': age,
        'ニックネーム': nickname,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _postText.clear();
      setState(() {
        _selectedArea.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: null,
              hint: const Text('希望地域を選択'),
              items: _japanArea.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  if (!_selectedArea.contains(newValue)) {
                    _selectedArea.add(newValue!);
                  }
                });
              },
            ),
          ),
          Wrap(
            children: _selectedArea.map((prefecture) {
              return Chip(
                label: Text(prefecture),
                onDeleted: () {
                  setState(() {
                    _selectedArea.remove(prefecture);
                  });
                },
              );
            }).toList(),
          ),
          TextField(
            controller: _postText,
            decoration: const InputDecoration(labelText: '募集内容'),
          ),
          ElevatedButton(
            onPressed: isButtonEnabled ? _addPost : null,
            child: const Text('投稿する'),
          ),
        ],
      ),
    );
  }
}
