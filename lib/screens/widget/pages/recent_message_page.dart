import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:sltsampleapp/screens/widget/pages/message_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/provider/provider.dart';

class RecentMessagePage extends HookConsumerWidget {
  const RecentMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;
    final messageStream = ref.watch(messageStreamProvider(currentUser!.uid));

    return Scaffold(
      body: messageStream.when(
        data: (messages) {
          if (messages.isEmpty) {
            return const Center(child: Text("メッセージ履歴なし"));
          } else {
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final otherUserUid =
                    message.userUid.firstWhere((uid) => uid != currentUser.uid);
                final getOtherUserUid =
                    ref.watch(getUserUidProvider(otherUserUid));
                final getTime = Utility.dateTimeConverter(
                    message.lastMessageTimestamp ?? DateTime.now());

                return getOtherUserUid.when(
                  data: (user) => Card(
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
                      subtitle: Text(message.lastMessage),
                      trailing: Text(getTime),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagePage(
                              currentUserUid: currentUser.uid,
                              receiverUid: otherUserUid,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) =>
                      const Center(child: Text('Error loading user details')),
                );
              },
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
