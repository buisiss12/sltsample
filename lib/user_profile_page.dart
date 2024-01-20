// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);
  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _nicknameController = TextEditingController();
  final _favoriteplaceController = TextEditingController();
  final _hashtagController = TextEditingController();
  final _introductionController = TextEditingController();
  final _statureController = TextEditingController();
  final _worklocationController = TextEditingController();
  final _livelocationController = TextEditingController();
  final _occupationController = TextEditingController();
  final _bodyshapeController = TextEditingController();
  final _holidayController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

        setState(() {
          _nicknameController.text =
              data.containsKey('ニックネーム') ? data['ニックネーム'] : '';
          _favoriteplaceController.text =
              data.containsKey('お気に入りの地域') ? data['お気に入りの地域'] : '';
          _hashtagController.text =
              data.containsKey('ハッシュタグ') ? data['ハッシュタグ'] : '';
          _introductionController.text =
              data.containsKey('自己紹介') ? data['自己紹介'] : '';
          _statureController.text = data.containsKey('身長') ? data['身長'] : '';
          _worklocationController.text =
              data.containsKey('勤務地') ? data['勤務地'] : '';
          _livelocationController.text =
              data.containsKey('居住地') ? data['居住地'] : '';
          _occupationController.text = data.containsKey('職種') ? data['職種'] : '';
          _bodyshapeController.text = data.containsKey('体型') ? data['体型'] : '';
          _holidayController.text = data.containsKey('休日') ? data['休日'] : '';
          _genderController.text = userData['性別'] ?? '';
          _birthdayController.text = userData['生年月日'] ?? '';
        });
      }
    } catch (error) {
      print('ロードユーザーデータエラー: $error');
    }
  }

  Future<void> _saveUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'ニックネーム': _nicknameController.text,
          'お気に入りの地域': _favoriteplaceController.text,
          'ハッシュタグ': _hashtagController.text,
          '自己紹介': _introductionController.text,
          '身長': _statureController.text,
          '勤務地': _worklocationController.text,
          '居住地': _livelocationController.text,
          '職種': _occupationController.text,
          '体型': _bodyshapeController.text,
          '休日': _holidayController.text,
          '性別': _genderController.text,
          '生年月日': _birthdayController.text,
        });
      }
    } catch (error) {
      print('サーブユーザーデータエラー: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        _saveUserData,
                        _nicknameController,
                        _favoriteplaceController,
                        _hashtagController,
                        _introductionController,
                        _statureController,
                        _worklocationController,
                        _livelocationController,
                        _occupationController,
                        _bodyshapeController,
                        _holidayController,
                        _genderController,
                        _birthdayController,
                      ),
                    ),
                  );
                },
                child: const Text("プロフィールを編集"),
              ),
              const Row(
                children: <Widget>[
                  Icon(Icons.emoji_events),
                  SizedBox(width: 8),
                  Text('REGULER'),
                ],
              ),
              const Divider(),
              const Row(
                children: <Widget>[
                  Icon(Icons.remember_me),
                  SizedBox(width: 8),
                  Text('会員ID:'),
                ],
              ),
              const Divider(),
              const Row(
                children: <Widget>[
                  Icon(Icons.perm_identity),
                  SizedBox(width: 8),
                  Text('身分証明書:'),
                ],
              ),
              const Divider(),
              const Row(
                children: <Widget>[
                  Icon(Icons.star_rate),
                  SizedBox(width: 8),
                  Text('特別会員:'),
                ],
              ),
              const Divider(),
              const Row(
                children: <Widget>[
                  Icon(Icons.military_tech),
                  SizedBox(width: 8),
                  Text('称号:'),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Icon(Icons.cake),
                  const SizedBox(width: 8),
                  Text('年齢: ${_birthdayController.text}'),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Icon(Icons.work),
                  const SizedBox(width: 8),
                  Text('職業: ${_occupationController.text}'),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Icon(Icons.apartment),
                  const SizedBox(width: 8),
                  Text('勤務地: ${_worklocationController.text}'),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Icon(Icons.home),
                  const SizedBox(width: 8),
                  Text('住居地: ${_livelocationController.text}'),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Icon(Icons.accessibility),
                  const SizedBox(width: 8),
                  Text('身長: ${_statureController.text}'),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Icon(Icons.accessibility_new),
                  const SizedBox(width: 8),
                  Text('体型: ${_bodyshapeController.text}'),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text('休日: ${_holidayController.text}'),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final Function onSave;
  final TextEditingController nicknameController;
  final TextEditingController favoriteplaceController;
  final TextEditingController hashtagController;
  final TextEditingController introductionController;
  final TextEditingController statureController;
  final TextEditingController worklocationController;
  final TextEditingController livelocationController;
  final TextEditingController occupationController;
  final TextEditingController bodyshapeController;
  final TextEditingController holidayController;
  final TextEditingController genderController;
  final TextEditingController birthdayController;

  const EditProfilePage(
      this.onSave,
      this.nicknameController,
      this.favoriteplaceController,
      this.hashtagController,
      this.introductionController,
      this.statureController,
      this.worklocationController,
      this.livelocationController,
      this.occupationController,
      this.bodyshapeController,
      this.holidayController,
      this.genderController,
      this.birthdayController,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("プロフィールを編集"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: "ニックネーム",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: favoriteplaceController,
                decoration: const InputDecoration(
                  labelText: "お気に入りの地域",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: hashtagController,
                decoration: const InputDecoration(
                  labelText: "ハッシュタグ",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: introductionController,
                decoration: const InputDecoration(
                  labelText: "自己紹介",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: statureController,
                decoration: const InputDecoration(
                  labelText: "身長",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: worklocationController,
                decoration: const InputDecoration(
                  labelText: "勤務地",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: livelocationController,
                decoration: const InputDecoration(
                  labelText: "住居地",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: occupationController,
                decoration: const InputDecoration(
                  labelText: "職種",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: bodyshapeController,
                decoration: const InputDecoration(
                  labelText: "体型",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: holidayController,
                decoration: const InputDecoration(
                  labelText: "休日",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(
                  labelText: "性別",
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              TextFormField(
                controller: birthdayController,
                decoration: const InputDecoration(
                  labelText: "生年月日",
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onSave();
                    Navigator.pop(context);
                  },
                  child: const Text("保存"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
