// ignore_for_file: avoid_print

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/before_login/login_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:flutter/material.dart';

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
            height: 120,
            child: DrawerHeader(child: Center(child: Text('設定'))),
          ),
          ListTile(
            title: const Text('各種設定'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('ログアウト'),
            onTap: () async {
              await Utility.showMyDialogAPI(
                context,
                "ログアウト",
                "ログアウトしますか？",
                () async {
                  await auth.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('アカウント削除'),
            onTap: () async {
              if (currentUser != null) {
                await Utility.showMyDialogAPI(
                  context,
                  "アカウント削除",
                  "本当にアカウントを削除しますか？",
                  () async {
                    await currentUser.delete();
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                );
              }
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
