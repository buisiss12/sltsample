import 'package:flutter_hooks/flutter_hooks.dart';
import 'solotte_page.dart';
import '../../provider/provider.dart';
import '../../models/model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPostPage extends HookConsumerWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);

    final selectedTodohuken = ref.watch(selectedTodohukenProvider);

    final post = useState('');

    void addPost() async {
      final currentUser = ref.watch(currentUserProvider);
      if (currentUser != null) {
        var userData =
            await firestore.collection('users').doc(currentUser.uid).get();
        var birthday = (userData['生年月日'] as Timestamp).toDate();
        var age = Models.birthdayToAge(birthday);
        var nickname = userData['ニックネーム'];
        var livearea = userData['居住地'];
        var profileImageUrl = userData['profileImageUrl'];

        await firestore.collection('posts').add({
          'UID': currentUser.uid,
          'ニックネーム': nickname,
          '年齢': age,
          '居住地': livearea,
          '希望地域': selectedTodohuken,
          '募集内容': post.value,
          'profileImageUrl': profileImageUrl,
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
            onTap: () => Models.showDialogtest(context, ref),
            controller:
                TextEditingController(text: selectedTodohuken.join(', ')),
            readOnly: true,
          ),
          const Text('募集内容'),
          TextField(
            decoration:
                const InputDecoration(labelText: '26日 19時くらいからオリラジ新宿か渋谷いきましょう'),
            onChanged: (value) {
              post.value = value;
            },
          ),
          ElevatedButton(
            onPressed: post.value.isNotEmpty && selectedTodohuken.isNotEmpty
                ? addPost
                : null,
            child: const Text('投稿する'),
          ),
        ],
      ),
    );
  }
}
