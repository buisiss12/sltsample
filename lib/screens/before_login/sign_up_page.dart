import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/screens/before_login/auth_repository.dart';

// 新規登録するView
class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: email,
              decoration: const InputDecoration(
                hintText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: 'パスワード',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref
                      .read(authRepositoryProvider)
                      .signUp(email.text, password.text);
                  // FirebaseAuthException書くなら、SnackBarやAlertDialogでエラーメッセージを表示すべき!
                } on FirebaseAuthException catch (e) {
                  // メールアドレスとパスワードが一致しない場合のSnackBarで日本語のエラーメッセージを表示
                  if(context.mounted) {
                    switch (e.code) {
                    case 'user-not-found':
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('メールアドレスが間違っています')),
                      );
                      break;
                    case 'wrong-password':
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('パスワードが間違っています')),
                      );
                      break;
                    default:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ログインに失敗しました')),
                      );
                  }
                  }
                }
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
