import 'provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculator.dart/age_calculator.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(firestoreProvider);

    final user = auth.currentUser;
    if (user == null) {
      return const Center(child: Text('ログインしてください'));
    }
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('users').doc(user.uid).get(),
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
        var birthday = userData['生年月日']?.toDate() ?? DateTime.now();
        var age = birthdayToAge(birthday);
        return ListView(
          children: <Widget>[
            Text('本名: ${userData['本名'] ?? ''}'),
            Text('年齢: $age'),
            Text('性別: ${userData['性別'] ?? ''}'),
            Text('勤務地: ${userData['勤務地'] ?? ''}'),
          ],
        );
      },
    );
  }
}
