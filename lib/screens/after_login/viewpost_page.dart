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
            return ListTile(
              title: Text(post.posttitle),
              subtitle: Text('希望エリア${post.todohuken} 投稿時間: ${post.timestamp}'),
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
