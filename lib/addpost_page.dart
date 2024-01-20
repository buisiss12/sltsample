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
  final _place = TextEditingController();
  final _postText = TextEditingController();

  void _addPost() async {
    if (_postText.text.isNotEmpty) {
      User? user = _auth.currentUser;
      if (user != null) {
        var userData = await _firestore.collection('users').doc(user.uid).get();
        var age = userData['生年月日'];
        var nickname = userData['ニックネーム'];

        await _firestore.collection('posts').add({
          '地域': _place.text,
          '募集内容': _postText.text,
          'UID': user.uid,
          '生年月日': age,
          'ニックネーム': nickname,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _postText.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            controller: _place,
            decoration: const InputDecoration(labelText: '地域'),
          ),
          TextField(
            controller: _postText,
            decoration: const InputDecoration(labelText: '募集内容'),
          ),
          ElevatedButton(
            onPressed: _addPost,
            child: const Text('投稿する'),
          ),
        ],
      ),
    );
  }
}
