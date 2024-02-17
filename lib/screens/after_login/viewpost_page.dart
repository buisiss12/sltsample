import 'package:sltsampleapp/models/model.dart';
import 'package:sltsampleapp/screens/after_login/chat_page.dart';
import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewPostPage extends HookConsumerWidget {
  const ViewPostPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;

    final postsStream = ref.watch(postsStreamProvider);

    return Scaffold(
      body: postsStream.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final getPostedUser =
                ref.watch(getPostedUserUIDProvider(post.postedUserUID));

            return ListTile(
              leading: getPostedUser.when(
                data: (user) => CircleAvatar(
                  radius: 40,
                  backgroundImage: user.profileImageUrl.isNotEmpty
                      ? NetworkImage(user.profileImageUrl)
                      : null,
                  child: user.profileImageUrl.isEmpty
                      ? Image.asset('assets/images/profiledefault.png')
                      : null,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => const Center(child: Icon(Icons.error)),
              ),
              title: getPostedUser.when(
                data: (user) => Text(user.nickname),
                loading: () => const SizedBox(),
                error: (e, st) => const Text('ニックネームの取得に失敗しました'),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('希望エリア: ${post.todohuken}'),
                  Text('投稿時間: ${datetimeConverter(post.timestamp!)}'),
                  Text('本文: ${post.posttitle}'),
                ],
              ),
              trailing: currentUser?.uid != post.postedUserUID
                  ? IconButton(
                      icon: const Icon(Icons.email),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              currentUserUID: currentUser!.uid,
                              receiverUID: post.postedUserUID,
                            ),
                          ),
                        );
                      },
                    )
                  : null,
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stac) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
