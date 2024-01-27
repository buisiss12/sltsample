import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPostPage extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  ViewPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _firestore
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
                            '希望地域: ${data['希望地域']} 生年月日: ${data['生年月日']}\n募集内容: ${data['募集内容']}'),
                      ),
                      const Divider(), // ここに Divider を追加
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
