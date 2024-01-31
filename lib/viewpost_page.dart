import 'provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewPostPage extends ConsumerWidget {
  const ViewPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final firestore = ref.watch(firebaseFirestoreProvider);
    final currentUserUid = auth.currentUser?.uid;

    return Scaffold(
      body: StreamBuilder(
        stream: firestore
            .collection('posts')
            .orderBy('timestamp', descending: true) //降順で並べ替え
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('viewpostpageエラーが発生しました');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                        leading: data['profileImageUrl'] != null &&
                                data['profileImageUrl'].isNotEmpty
                            ? Image.network(data['profileImageUrl'],
                                width: 50, height: 50)
                            : Image.asset('assets/images/profilepic.webp',
                                width: 50, height: 50),
                        title: Text(data['ニックネーム']),
                        subtitle: Text(
                            '${data['年齢']}歳 居住地: ${data['居住地']}\n希望地域: ${data['希望地域']}\n募集内容: ${data['募集内容']}'),
                        trailing: currentUserUid != data['UID']
                            ? IconButton(
                                icon: const Icon(Icons.mail),
                                onPressed: () {
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        userUid: data['UID'],
                                        userNickName: data['ニックネーム'],
                                      ),
                                    ),
                                  );*/
                                },
                              )
                            : null,
                      ),
                      const Divider(),
                    ],
                  );
                })
                .expand((element) => [element])
                .toList(),
          );
        },
      ),
    );
  }
}
