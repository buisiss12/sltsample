// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 100, // ここでヘッダーの高さを調整
            child: DrawerHeader(
              child: Center(
                child: Text('設定'),
              ),
            ),
          ),
          ListTile(
            title: const Text('ブロック済みのユーザー'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('各種設定'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('ログアウト'),
            onTap: () async {
              Navigator.of(context).pop();
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } on FirebaseAuthException catch (e) {
                print('ログアウト失敗: $e');
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('よくある質問'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('お問い合わせ'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('ORIENTAL LOUNGE(オリエンタルラウンジ)HP'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('ag(アグ)HP'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('リクルート'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('アプリを評価する'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('利用規約'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('アカウント削除'),
            onTap: () async {
              Navigator.of(context).pop();
              try {
                await FirebaseAuth.instance.currentUser?.delete();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } on FirebaseAuthException catch (e) {
                print('アカウント削除失敗: $e');
              }
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
