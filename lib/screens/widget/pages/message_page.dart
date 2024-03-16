import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/models/message_model.dart';

class MessagePage extends HookConsumerWidget {
  final String currentUserUid;
  final String receiverUid;

  const MessagePage({
    Key? key,
    required this.currentUserUid,
    required this.receiverUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);
    final chatService = ChatService(firestore);
    final chatText = useTextEditingController();
    final scrollController = useScrollController();
    final receiverUserDetails = ref.watch(getUserUidProvider(receiverUid));

    void sendMessage() async {
      if (chatText.text.isEmpty) return;
      List<String> ids = [currentUserUid, receiverUid]..sort();
      String chatId = ids.join("_");

      final chatModel = MessageModel(
        senderUid: currentUserUid,
        receiverUid: receiverUid,
        text: chatText.text,
        userUid: chatId,
        timestamp: DateTime.now(),
      );
      await chatService.sendMessage(chatModel);
      chatText.clear();

      // メッセージ送信後に最下部にスクロール
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: receiverUserDetails.when(
            data: (user) => Text(user.nickName),
            loading: () => const Text('ロード中...'),
            error: (_, __) => const Text('エラー'),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: chatService.getMessages(currentUserUid, receiverUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (snapshot.hasData) {
                      // メッセージが来たとき、最下部にスクロール
                      if (scrollController.hasClients) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    }
                  });
                  final messages = snapshot.data ?? [];
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final bool isMe = message.senderUid == currentUserUid;
                      return Container(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                Utility.dateTimeConverter(message.timestamp),
                                style: TextStyle(
                                  color: isMe ? Colors.white70 : Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: chatText,
                decoration: InputDecoration(
                  hintText: "メッセージを入力",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatService {
  final FirebaseFirestore firestore;

  ChatService(this.firestore);

  Future<void> sendMessage(MessageModel chatMessage) async {
    List<String> ids = [chatMessage.senderUid, chatMessage.receiverUid]..sort();
    String chatId = ids.join("_");
    final conversationRef = firestore.collection('conversations').doc(chatId);

    final conversationSnapshot = await conversationRef.get();
    if (!conversationSnapshot.exists) {
      await conversationRef.set({
        'userUid': [chatMessage.senderUid, chatMessage.receiverUid],
        'lastMessage': chatMessage.text,
        'lastMessageTimestamp': chatMessage.timestamp.toString(),
      });
    } else {
      await conversationRef.update({
        'lastMessage': chatMessage.text,
        'lastMessageTimestamp': chatMessage.timestamp.toString(),
      });
    }
    await conversationRef.collection('messages').add(chatMessage.toJson());
  }

  Stream<List<MessageModel>> getMessages(String senderUid, String receiverUid) {
    List<String> ids = [senderUid, receiverUid]..sort();
    String chatId = ids.join("_");

    return firestore
        .collection('conversations')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();
      },
    );
  }
}
