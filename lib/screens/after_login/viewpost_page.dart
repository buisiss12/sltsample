import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewPostPage extends HookConsumerWidget {
  const ViewPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stac) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
