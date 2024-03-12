import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:sltsampleapp/models/user_model.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/widget/pages/addpost_page.dart';
import 'package:sltsampleapp/screens/widget/pages/message_page.dart';
import 'package:sltsampleapp/utils/utility.dart';

class PostsPage extends HookConsumerWidget {
  const PostsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utility = Utility();
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
                          Text(Utility.dateTimeConverter(post.timestamp!)),
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
                                        utility.showSnackBarAPI(
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
                                  onTap: () async {
                                    Utility.showDialogAPI(
                                      context,
                                      '投稿を削除',
                                      'この投稿を削除してもよろしいですか？',
                                      () async {
                                        await firestore
                                            .collection('posts')
                                            .doc(post.postId)
                                            .delete();
                                      },
                                    );
                                  },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostPage()),
          );
        },
        child: const Icon(Icons.edit_note),
      ),
    );
  }
}
