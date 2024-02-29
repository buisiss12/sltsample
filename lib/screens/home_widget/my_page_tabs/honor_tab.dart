import 'package:flutter/material.dart';

class HonorTab extends StatelessWidget {
  const HonorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('オリエンタルラウンジ・agへのご来店や滞在で付与される称号です。'),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('称号 テスト'),
            subtitle: Text('メーター'),
          ),
        ],
      ),
    );
  }
}
