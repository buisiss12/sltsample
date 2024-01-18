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

  void _addPost() async {
    if (_postText.text.isNotEmpty) {
      await _firestore.collection('posts').add({
        'text': _postText.text,
        'uid': _auth.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _postText.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            controller: _postText,
            decoration: const InputDecoration(labelText: 'メッセージを入力'),
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
