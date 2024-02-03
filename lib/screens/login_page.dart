// ignore_for_file: avoid_print

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'resistration_page.dart';
import 'forgetpw_page.dart';
import 'oldmember_resistration_page.dart';
import 'solotte_page.dart';
import '../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final phoneNumber = ref.watch(phoneNumberProvider);
    final passWord = ref.watch(passWordProvider);
    final hidePassword = ref.watch(hidePasswordProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/1080x384solotte.png'),
              const Text('ログイン',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('電話番号 または 会員ID',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration:
                    const InputDecoration(labelText: '電話番号または会員IDを入力(ハイフンなし)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  ref.read(phoneNumberProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 16),
              const Text('パスワード (数字6桁以上)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  labelText: 'パスワードを入力',
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      ref.read(hidePasswordProvider.notifier).state =
                          !hidePassword;
                    },
                  ),
                ),
                obscureText: hidePassword,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  ref.read(passWordProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: phoneNumber.isNotEmpty && passWord.isNotEmpty
                    ? () async {
                        try {
                          await auth.signInWithEmailAndPassword(
                            email: '$phoneNumber@test.com',
                            password: passWord,
                          );
                          print('ログイン成功');

                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SolottePage()),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          print('ログイン失敗: $e');
                        }
                      }
                    : null,
                child: const Text('ログイン'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPwPage()),
                  );
                },
                child: const Text('パスワードを忘れてしまった場合'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationPage()),
                  );
                },
                child: const Text('新規会員登録'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OldMemberPage()),
                  );
                },
                child: const Text('以前会員登録した方はこちら'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
