import 'package:flutter_hooks/flutter_hooks.dart';
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

    void sendMessage() async {
      List<String> ids = [currentUserUID, receiverUID]..sort();
      String chatId = ids.join("_");

      final chatMessage = ChatModel(
        senderUID: currentUserUID,
        receiverUID: receiverUID,
        text: chatText.text,
        chatId: chatId,
        timestamp: DateTime.now(),
      );
      await chatService.sendMessage(chatMessage);
      chatText.clear();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: chatService.getMessages(currentUserUID, receiverUID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data ?? [];
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(message.timestamp.toString()),
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
    );
  }
}

class ChatService {
  final FirebaseFirestore firestore;

  ChatService(this.firestore);

  Future<void> sendMessage(ChatModel chatMessage) async {
    await firestore.collection('chats').add(chatMessage.toJson());
  }

  Stream<List<ChatModel>> getMessages(String senderUID, String receiverUID) {
    List<String> ids = [senderUID, receiverUID]..sort();
    String chatId = ids.join("_");
    return firestore
        .collection('chats')
        .where('chatId', isEqualTo: chatId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatModel.fromJson(doc.data()))
          .toList();
    });
  }
}
