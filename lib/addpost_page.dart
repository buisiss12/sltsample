import 'solotte_page.dart';
import 'provider/provider.dart';
import 'models/user_model.dart';
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

    final selectedArea = ref.watch(selectedAreaProvider);
    final post = ref.watch(addPostProvider);

    void addPost() async {
      User? user = auth.currentUser;
      if (user != null) {
        var userData = await firestore.collection('users').doc(user.uid).get();
        var birthday = (userData['生年月日'] as Timestamp).toDate();
        var nickname = userData['ニックネーム'];
        var age = Utils.birthdayToAge(birthday);
        var livearea = userData['居住地'];

        await firestore.collection('posts').add({
          'UID': user.uid,
          'ニックネーム': nickname,
          '年齢': age,
          '居住地': livearea,
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
          const Text('募集条件'),
          TextFormField(
            decoration: const InputDecoration(labelText: '希望地域'),
            onTap: () => Utils.showDialogtest(context, ref),
            controller: TextEditingController(text: selectedArea.join(', ')),
            readOnly: true,
          ),
          const Text('募集内容'),
          TextField(
            decoration:
                const InputDecoration(labelText: '26日 19時くらいからオリラジ新宿か渋谷いきましょう'),
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
