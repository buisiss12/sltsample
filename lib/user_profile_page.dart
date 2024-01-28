import 'provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculator/age_calculator.dart';

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
            Text('ニックネーム: ${userData['ニックネーム'] ?? ''}'),
            Text('年齢: $age歳'),
            Text('性別: ${userData['性別'] ?? ''}'),
            Text('勤務地: ${userData['勤務地'] ?? ''}'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfilePage(initialData: userData),
                  ),
                );
              },
              child: const Text('編集する'),
            ),
          ],
        );
      },
    );
  }
}

class EditProfilePage extends ConsumerWidget {
  final Map<String, dynamic> initialData;

  const EditProfilePage({super.key, required this.initialData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(firestoreProvider);
    final user = auth.currentUser;

    final nicknameController =
        TextEditingController(text: initialData['ニックネーム']);
    final genderController = TextEditingController(text: initialData['性別']);
    final locationController = TextEditingController(text: initialData['勤務地']);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          TextField(
              controller: nicknameController,
              decoration: const InputDecoration(labelText: 'ニックネーム')),
          TextField(
              enabled: false,
              controller: genderController,
              decoration: const InputDecoration(labelText: '性別')),
          TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: '勤務地')),
          ElevatedButton(
            onPressed: () {
              Map<String, dynamic> updatedData = {};
              if (nicknameController.text.isNotEmpty) {
                updatedData['ニックネーム'] = nicknameController.text;
              }
              if (genderController.text.isNotEmpty) {
                updatedData['性別'] = genderController.text;
              }
              if (locationController.text.isNotEmpty) {
                updatedData['勤務地'] = locationController.text;
              }
              firestore.collection('users').doc(user?.uid).update(updatedData);
              Navigator.pop(context);
            },
            child: const Text('更新'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }
}
