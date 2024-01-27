import 'provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewPostPage extends ConsumerWidget {
  const ViewPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firestoreProvider);

    return Scaffold(
      body: StreamBuilder(
        stream: firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
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
                        title: Text(data['ニックネーム']),
                        subtitle: Text(
                            '希望地域: ${data['希望地域']} 年齢: ${data['年齢']}\n募集内容: ${data['募集内容']}'),
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
