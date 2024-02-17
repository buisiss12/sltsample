import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sltsampleapp/models/model.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:sltsampleapp/screens/after_login/solotte_page.dart';
import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPostPage extends HookConsumerWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postTitle = useState('');

    final selectedTodohuken = useState<List<String>>([]);

    Future<void> addPost() async {
      final auth = ref.watch(firebaseAuthProvider);
      final currentUser = auth.currentUser;
      final firestore = ref.watch(firebaseFirestoreProvider);
      if (currentUser != null &&
          postTitle.value.isNotEmpty &&
          selectedTodohuken.value.isNotEmpty) {
        final userDoc =
            await firestore.collection('users').doc(currentUser.uid).get();
        final userNickname = userDoc.data()?['nickname'];
        if (userNickname == null || userNickname.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ニックネームを編集してください')),
            );
          }
          return;
        }
        final postModel = PostModel(
          postedUserUID: currentUser.uid,
          todohuken: selectedTodohuken.value,
          posttitle: postTitle.value,
          timestamp: DateTime.now(),
        );

        await firestore.collection('posts').add(postModel.toJson());

        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const SolottePage(),
          ));
        }
      }
    }

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const Text('希望地域'),
              TextField(
                onTap: () => Logics.show(context, selectedTodohuken),
                controller: TextEditingController(
                    text: selectedTodohuken.value.join(', ')),
                readOnly: true,
              ),
              const Text('募集内容'),
              TextField(
                onChanged: (value) {
                  postTitle.value = value;
                },
              ),
              ElevatedButton(
                onPressed: postTitle.value.isNotEmpty &&
                        selectedTodohuken.value.isNotEmpty
                    ? addPost
                    : null,
                child: const Text('投稿する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
