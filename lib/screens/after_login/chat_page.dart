import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sltsampleapp/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sltsampleapp/provider/provider.dart';

class ChatPage extends HookConsumerWidget {
  final String currentUserUID;
  final String receiverUID;

  const ChatPage({
    Key? key,
    required this.currentUserUID,
    required this.receiverUID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);
    final chatService = ChatService(firestore);
    final chatText = useTextEditingController();
    final scrollController = useScrollController();

    void sendMessage() async {
      if (chatText.text.isEmpty) return;
      List<String> ids = [currentUserUID, receiverUID]..sort();
      String chatId = ids.join("_");

      final chatMessage = ChatModel(
        senderUID: currentUserUID,
        receiverUID: receiverUID,
        text: chatText.text,
        userUIDs: chatId,
        timestamp: DateTime.now(),
      );
      await chatService.sendMessage(chatMessage);
      chatText.clear();

      // メッセージ送信後に最下部にスクロール
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: chatService.getMessages(currentUserUID, receiverUID),
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
                    final bool isMe = message.senderUID == currentUserUID;
                    return Container(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
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
                                  color: isMe ? Colors.white : Colors.black),
                            ),
                            Text(
                              DateFormat('HH:mm').format(message.timestamp!),
                              style: TextStyle(
                                  color: isMe ? Colors.white70 : Colors.black54,
                                  fontSize: 10),
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
              onSubmitted: (_) => sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatService {
  final FirebaseFirestore firestore;

  ChatService(this.firestore);

  Future<void> sendMessage(ChatModel chatMessage) async {
    List<String> ids = [chatMessage.senderUID, chatMessage.receiverUID]..sort();
    String chatId = ids.join("_");
    final conversationRef = firestore.collection('conversations').doc(chatId);

    final conversationSnapshot = await conversationRef.get();
    if (!conversationSnapshot.exists) {
      await conversationRef.set({
        'userUIDs': [chatMessage.senderUID, chatMessage.receiverUID],
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

  Stream<List<ChatModel>> getMessages(String senderUID, String receiverUID) {
    List<String> ids = [senderUID, receiverUID]..sort();
    String chatId = ids.join("_");

    return firestore
        .collection('conversations')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatModel.fromJson(doc.data()))
          .toList();
    });
  }
}
