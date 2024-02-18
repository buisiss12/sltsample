import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/after_login/message_page.dart';

class RecentMessagePage extends HookConsumerWidget {
  const RecentMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;
    final messageStream = ref.watch(messageStreamProvider(currentUser!.uid));

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        body: messageStream.when(
          data: (conversations) => ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final userUid = conversation.userUid.firstWhere(
                  (uid) => uid != currentUser.uid,
                  orElse: () => currentUser.uid);
              final userDetailAsyncValue =
                  ref.watch(userDetailProvider(userUid));

              final elapsedTime = dateTimeConverter(
                  conversation.lastMessageTimestamp ?? DateTime.now());

              return ListTile(
                leading: userDetailAsyncValue.when(
                  data: (user) => CircleAvatar(
                    radius: 40,
                    backgroundImage: user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: user.profileImageUrl.isEmpty
                        ? Image.asset('assets/images/300x300defaultprofile.png')
                        : null,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Icon(Icons.error)),
                ),
                title: userDetailAsyncValue.when(
                  data: (user) => Text(user.nickName),
                  loading: () => const Text("Loading..."),
                  error: (_, __) => const Text("Error"),
                ),
                subtitle: Text(conversation.lastMessage),
                trailing: Text(elapsedTime),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagePage(
                        currentUserUid: currentUser.uid,
                        receiverUid: userUid,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
