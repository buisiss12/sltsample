import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/home_1/solotte_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPostPage extends HookConsumerWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postTitle = useState('');

    final selectedPrefecture = useState<List<String>>([]);

    Future<void> addPost() async {
      final auth = ref.watch(firebaseAuthProvider);
      final currentUser = auth.currentUser;
      final firestore = ref.watch(firebaseFirestoreProvider);
      if (currentUser != null &&
          postTitle.value.isNotEmpty &&
          selectedPrefecture.value.isNotEmpty) {
        final userDoc =
            await firestore.collection('users').doc(currentUser.uid).get();
        final userNickname = userDoc.data()?['nickName'];
        if (userNickname == null || userNickname.isEmpty) {
          if (context.mounted) {
            Utility.showSnackBarAPI(context, 'ニックネームを入力してください');
          }
          return;
        }
        final postModel = PostModel(
          postId: '',
          postedUserUid: currentUser.uid,
          prefecture: selectedPrefecture.value,
          postTitle: postTitle.value,
          timestamp: DateTime.now(),
        );

        final documentRef =
            await firestore.collection('posts').add(postModel.toJson());
        final postId = documentRef.id;

        await firestore
            .collection('posts')
            .doc(postId)
            .update({'postId': postId});

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SolottePage()));
        }
      }
    }

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                const Text('(注意事項)'),
                const Text('*アイコンがご自身が写った写真に設定していない場合、投稿を削除いたします。'),
                const Text(
                    '*宣伝、ネットワークビジネス、パーティー業者と見受けられるものは禁止となっております。見つけ次第、削除退会処置を取ります。'),
                const SizedBox(height: 16),
                const Text('希望地域'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '希望地域を選択',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                      text: selectedPrefecture.value.join(', ')),
                  readOnly: true,
                  onTap: () => Utility.selectMultiPrefectureDialog(
                    context,
                    selectedPrefecture,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('募集内容'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '本文',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  minLines: 4,
                  onChanged: (value) {
                    postTitle.value = value;
                  },
                ),
                ElevatedButton(
                  onPressed: postTitle.value.isNotEmpty &&
                          selectedPrefecture.value.isNotEmpty
                      ? addPost
                      : null,
                  child: const Text('投稿する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
