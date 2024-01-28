import 'solotte_page.dart';
import 'calculator/age_calculator.dart';
import 'provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostPage extends ConsumerWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(firestoreProvider);

    final post = ref.watch(addPostProvider);
    final area = ref.watch(areaProvider);
    final selectedArea = ref.watch(selectedAreaProvider);

    void addPost() async {
      User? user = auth.currentUser;
      if (user != null) {
        var userData = await firestore.collection('users').doc(user.uid).get();
        var birthday = (userData['生年月日'] as Timestamp).toDate();
        var age = birthdayToAge(birthday);
        var nickname = userData['ニックネーム'];

        if (nickname == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('プロフィールを完成させてください')));
            return;
          }
        }

        await firestore.collection('posts').add({
          'ニックネーム': nickname,
          'UID': user.uid,
          '年齢': age,
          '希望地域': selectedArea,
          '募集内容': post,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SolottePage(),
        ));
      }
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            hint: const Text("地域を選択"),
            value: null,
            onChanged: (String? newValue) {
              if (newValue != null && !selectedArea.contains(newValue)) {
                ref.read(selectedAreaProvider.notifier).state = [
                  ...selectedArea,
                  newValue
                ];
              }
            },
            items: area.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Wrap(
            children: selectedArea
                .map((e) => Chip(
                      label: Text(e),
                      onDeleted: () {
                        ref.read(selectedAreaProvider.notifier).state =
                            selectedArea
                                .where((element) => element != e)
                                .toList();
                      },
                    ))
                .toList(),
          ),
          TextField(
            decoration: const InputDecoration(labelText: '募集内容'),
            onChanged: (value) {
              ref.read(addPostProvider.notifier).state = value;
            },
          ),
          ElevatedButton(
            onPressed:
                post.isNotEmpty && selectedArea.isNotEmpty ? addPost : null,
            child: const Text('投稿する'),
          ),
        ],
      ),
    );
  }
}
