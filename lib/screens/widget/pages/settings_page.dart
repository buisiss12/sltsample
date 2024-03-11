import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/widget/pages/login_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:flutter/material.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;
    final utility = Utility();

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: <Widget>[
          const Divider(),
          ListTile(
            title: const Text('ログアウト'),
            onTap: () async {
              await Utility.showDialogAPI(
                context,
                "ログアウト",
                "ログアウトしますか？",
                () async {
                  try {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      utility.showSnackBarAPI(context, 'ログアウト失敗: $e');
                    }
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
                await Utility.showDialogAPI(
                  context,
                  "アカウント削除",
                  "本当にアカウントを削除しますか？",
                  () async {
                    try {
                      await currentUser.delete();
                      await auth.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        utility.showSnackBarAPI(context, 'アカウント削除失敗: $e');
                      }
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
