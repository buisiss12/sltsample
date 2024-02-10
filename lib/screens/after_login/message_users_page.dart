import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/provider/provider.dart';

class MessageUsersPage extends HookConsumerWidget {
  const MessageUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;
    final messageStream = ref.watch(messageStreamProvider(currentUser!.uid));

    return Scaffold(
      body: messageStream.when(
        data: (conversations) => ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return ListTile(
              title: Text(conversation.userUIDs.join(", ")),
              subtitle: Text(conversation.lastMessage),
              onTap: () {},
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
