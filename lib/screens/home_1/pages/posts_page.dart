import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sltsampleapp/models/user_model.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/home_1/pages/message_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostsPage extends HookConsumerWidget {
  const PostsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;
    final firestore = ref.watch(firebaseFirestoreProvider);

    final postsStream = ref.watch(postsStreamProvider);

    return Scaffold(
      body: postsStream.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return FutureBuilder<UserModel>(
              future:
                  ref.read(getPostedUserUidProvider(post.postedUserUid).future),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final user = snapshot.data!;

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: user.profileImageUrl.isNotEmpty
                            ? NetworkImage(user.profileImageUrl)
                            : const AssetImage(
                                    'assets/images/300x300defaultprofile.png')
                                as ImageProvider,
                      ),
                      title: Text(user.nickName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('希望エリア: ${post.prefecture}'),
                          Text('本文: ${post.postTitle}'),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          Text(dateTimeConverter(post.timestamp!)),
                          const SizedBox(height: 8),
                          currentUser?.uid != post.postedUserUid
                              ? InkWell(
                                  child: const Icon(
                                    Icons.email,
                                    size: 28.0,
                                  ),
                                  onTap: () async {
                                    final userDoc = await firestore
                                        .collection('users')
                                        .doc(currentUser?.uid)
                                        .get();
                                    final userNickname =
                                        userDoc.data()?['nickName'];
                                    if (userNickname == null ||
                                        userNickname.isEmpty) {
                                      if (context.mounted) {
                                        Utility.showSnackBarAPI(
                                            context, 'ニックネームを入力してください');
                                      }
                                      return;
                                    }
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MessagePage(
                                            currentUserUid: currentUser!.uid,
                                            receiverUid: post.postedUserUid,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                )
                              : InkWell(
                                  child: const Icon(
                                    Icons.delete,
                                    size: 28.0,
                                  ),
                                  onTap: () => _deletePostDialog(
                                      context, firestore, post.postId),
                                ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _deletePostDialog(
      BuildContext context, FirebaseFirestore firestore, String postId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('投稿を削除'),
          content: const Text('この投稿を削除してもよろしいですか？'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                await firestore.collection('posts').doc(postId).delete();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }
}
