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
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _occupationController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _genderController.text = userData['gender'];
        _birthdayController.text = userData['birthdate'];
        _occupationController.text = userData['occupation'] ?? '';
        _locationController.text = userData['location'] ?? '';
      });
    }
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'gender': _genderController.text,
        'birthdate': _birthdayController.text,
        'occupation': _occupationController.text,
        'location': _locationController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      _genderController,
                      _birthdayController,
                      _occupationController,
                      _locationController,
                    ),
                  ),
                );
              },
              child: const Text("プロフィールを編集"),
            ),
            TextFormField(
              controller: _genderController,
              decoration: const InputDecoration(
                labelText: "性別",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            TextFormField(
              controller: _birthdayController,
              decoration: const InputDecoration(
                labelText: "生年月日",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            TextFormField(
              controller: _occupationController,
              decoration: const InputDecoration(
                labelText: "職業",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "住居地",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final Function onSave;
  final TextEditingController genderController;
  final TextEditingController birthdayController;
  final TextEditingController occupationController;
  final TextEditingController locationController;

  const EditProfilePage(
      this.onSave,
      this.genderController,
      this.birthdayController,
      this.occupationController,
      this.locationController,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            TextFormField(
              controller: occupationController,
              decoration: const InputDecoration(
                labelText: "職業",
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "住居地",
                border: OutlineInputBorder(),
              ),
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
    );
  }
}
