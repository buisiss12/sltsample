// ignore_for_file: avoid_print

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/provider/provider.dart';
import '../before_login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

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
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
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
                await currentUser?.delete();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
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
