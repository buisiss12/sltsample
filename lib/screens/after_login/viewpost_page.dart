import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewPostPage extends ConsumerWidget {
  const ViewPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);
    final currentUser = ref.watch(currentUserProvider);
    final currentUserUid = currentUser?.uid;

    final viewPosts = firestore
        .collection('posts')
        .orderBy('timestamp', descending: true) //降順で並べ替え
        .snapshots();

    return Scaffold(
      body: StreamBuilder(
        stream: viewPosts,
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
                  Map<String, dynamic> userData =
                      document.data()! as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                        leading: userData['profileImageUrl'] != null &&
                                userData['profileImageUrl'].isNotEmpty
                            ? Image.network(userData['profileImageUrl'],
                                width: 50, height: 50)
                            : Image.asset('assets/images/profilepic.webp',
                                width: 50, height: 50),
                        title: Text(userData['ニックネーム']),
                        subtitle: Text(
                            '${userData['年齢']}歳 居住地: ${userData['居住地']}\n希望地域: ${userData['希望地域']}\n募集内容: ${userData['募集内容']}'),
                        trailing: currentUserUid != userData['UID']
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
