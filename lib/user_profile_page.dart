import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('ログインしてください'));
    }
    return StreamBuilder<DocumentSnapshot>(
      //futureビルダーへ変更
      stream: _firestore.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('エラーが発生しました'));
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('ユーザーデータが見つかりません'));
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        return ListView(
          children: <Widget>[
            Text('本名: ${userData['本名'] ?? ''}'),
            Text('生年月日: ${userData['生年月日'] ?? ''}'),
            Text('性別: ${userData['性別'] ?? ''}'),
            Text('勤務地: ${userData['勤務地'] ?? ''}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserProfileEditPage(userData: userData)),
                );
              },
              child: const Text('プロフィールを編集'),
            ),
          ],
        );
      },
    );
  }
}

class UserProfileEditPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserProfileEditPage({Key? key, required this.userData})
      : super(key: key);

  @override
  UserProfileEditPageState createState() => UserProfileEditPageState();
}

class UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _workplaceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['本名']);
    _genderController = TextEditingController(text: widget.userData['性別']);
    _workplaceController = TextEditingController(text: widget.userData['勤務地']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _workplaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '本名'),
            ),
            TextFormField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: '性別'),
              enabled: false,
            ),
            TextFormField(
              controller: _workplaceController,
              decoration: const InputDecoration(labelText: '勤務地'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateUserProfile();
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserProfile() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    var user = auth.currentUser;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).update({
        '本名': _nameController.text,
        '性別': _genderController.text,
        '勤務地': _workplaceController.text,
      });

      Navigator.pop(context);
    }
  }
}
