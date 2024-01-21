import 'package:flutter/material.dart';
import 'solotte_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final addPostProvider = StateProvider<String>((ref) => '');
final selectedAreaProvider = StateProvider<List<String>>((ref) => []);

class AddPostPage extends ConsumerWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final post = ref.watch(addPostProvider);
    final selectedArea = ref.watch(selectedAreaProvider);

    void addPost() async {
      User? user = auth.currentUser;
      if (user != null) {
        var userData = await firestore.collection('users').doc(user.uid).get();
        var age = userData['生年月日'];
        var nickname = userData['ニックネーム'];

        await firestore.collection('posts').add({
          'UID': user.uid,
          '生年月日': age,
          'ニックネーム': nickname,
          '募集内容': post,
          '希望地域': selectedArea,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const SolottePage(),
      ));
      ref.read(addPostProvider.notifier).state = '';
      ref.read(selectedAreaProvider.notifier).state = [];
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: null,
              hint: const Text('都道府県を選択'),
              items: [
                '北海道',
                '青森県',
                '岩手県',
                '宮城県',
                '秋田県',
                '山形県',
                '福島県',
                '茨城県',
                '栃木県',
                '群馬県',
                '埼玉県',
                '千葉県',
                '東京都',
                '神奈川県',
                '新潟県',
                '富山県',
                '石川県',
                '福井県',
                '山梨県',
                '長野県',
                '岐阜県',
                '静岡県',
                '愛知県',
                '三重県',
                '滋賀県',
                '京都府',
                '大阪府',
                '兵庫県',
                '奈良県',
                '和歌山県',
                '鳥取県',
                '島根県',
                '岡山県',
                '広島県',
                '山口県',
                '徳島県',
                '香川県',
                '愛媛県',
                '高知県',
                '福岡県',
                '佐賀県',
                '長崎県',
                '熊本県',
                '大分県',
                '宮崎県',
                '鹿児島県',
                '沖縄県',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && !selectedArea.contains(newValue)) {
                  ref.read(selectedAreaProvider.notifier).state =
                      List.from(selectedArea)..add(newValue);
                }
              },
            ),
          ),
          Wrap(
            children: selectedArea
                .map((prefecture) => Chip(
                    label: Text(prefecture),
                    onDeleted: () => ref
                            .read(selectedAreaProvider.notifier)
                            .state =
                        selectedArea.where((p) => p != prefecture).toList()))
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
