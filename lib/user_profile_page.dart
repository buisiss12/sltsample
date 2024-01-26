import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sltsampleapp/providers.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      body: userProfile.when(
        data: (DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('本名: ${data['本名'] ?? ''}'),
                  Text('性別: ${data['性別'] ?? ''}'),
                ],
              ),
            );
          } else {
            return const Center(child: Text('プロフィールが見つかりません'));
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('エラー: $error')),
      ),
    );
  }
}
