import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class UserProfilePage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      body: user != null
          ? FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData && snapshot.data != null) {
                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('本名: ${userData['本名'] ?? ''}'),
                          Text('生年月日: ${userData['生年月日'] ?? ''}'),
                          Text('性別: ${userData['性別'] ?? ''}'),
                          Text('職場: ${userData['職場'] ?? ''}'),
                        ],
                      ),
                    );
                  } else {
                    return const Text("ユーザーデータは利用不可");
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          : const Text("ユーザーはログインしていません"),
    );
  }
}
