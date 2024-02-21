// ignore_for_file: avoid_print

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/before_login/login_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerPage extends ConsumerWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 100,
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
                await auth.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (context.mounted) {
                  Utility.showSnackBar(context, 'ログアウト失敗: ${e.message}');
                }
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
                if (context.mounted) {
                  Utility.showSnackBar(context, 'アカウント削除失敗: ${e.message}');
                }
              }
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
