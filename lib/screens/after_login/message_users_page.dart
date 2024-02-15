import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/models/model.dart';
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
            final userUID = conversation.userUIDs.firstWhere(
                (uid) => uid != currentUser.uid,
                orElse: () => currentUser.uid);
            final userDetailAsyncValue = ref.watch(userDetailProvider(userUID));

            final elapsedTime = datetimeConverter(
                conversation.lastMessageTimestamp ?? DateTime.now());

            return ListTile(
              leading: userDetailAsyncValue.when(
                data: (user) => CircleAvatar(
                  radius: 40,
                  backgroundImage: user.profileImageUrl.isNotEmpty
                      ? NetworkImage(user.profileImageUrl)
                      : null,
                  child: user.profileImageUrl.isEmpty
                      ? Image.asset('assets/images/profiledefault.png')
                      : null,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Icon(Icons.error),
              ),
              title: userDetailAsyncValue.when(
                data: (user) => Text(user.nickname),
                loading: () => const Text("Loading..."),
                error: (_, __) => const Text("Error"),
              ),
              subtitle: Text(conversation.lastMessage),
              trailing: Text(elapsedTime),
              onTap: () {},
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
