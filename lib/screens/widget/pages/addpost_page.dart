import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/home.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPostPage extends ConsumerStatefulWidget {
  const AddPostPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {
  final utility = Utility();

  String postTitle = "";
  // ValueNotifierは値が変更されたときに、変更を検知して通知する
  final selectedPrefecture = ValueNotifier<List<String>>([]);

  @override
  void dispose() {
    selectedPrefecture.dispose();
    super.dispose();
  }

  Future<void> addPost() async {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;
    final firestore = ref.watch(firebaseFirestoreProvider);
    if (currentUser != null &&
        postTitle.isNotEmpty &&
        selectedPrefecture.value.isNotEmpty) {
      final userDoc =
          await firestore.collection('users').doc(currentUser.uid).get();
      final userNickname = userDoc.data()?['nickName'];
      if (userNickname == null || userNickname.isEmpty) {
        if (mounted) {
          utility.showSnackBarAPI(context, 'ニックネームを入力してください');
        }
        return;
      }
      final postModel = PostModel(
        postId: '',
        postedUserUid: currentUser.uid,
        prefecture: selectedPrefecture.value,
        postTitle: postTitle,
        timestamp: DateTime.now(),
      );

      final documentRef =
          await firestore.collection('posts').add(postModel.toJson());
      final postId = documentRef.id;

      await firestore
          .collection('posts')
          .doc(postId)
          .update({'postId': postId});

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('投稿')),
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
                ValueListenableBuilder<List<String>>(
                  valueListenable: selectedPrefecture,
                  builder: (context, selectedPrefectures, _) {
                    return TextField(
                      controller: TextEditingController(
                        text: selectedPrefectures.join(", "),
                      ),
                      decoration: const InputDecoration(
                        hintText: '希望地域を選択',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () => utility.selectMultiPrefectureDialog(
                        context,
                        selectedPrefecture,
                      ),
                    );
                  },
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
                    setState(() {
                      postTitle = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: postTitle.isNotEmpty &&
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
