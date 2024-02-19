// ignore_for_file: avoid_print

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'resistration_page.dart';
import 'forgetpw_page.dart';
import 'oldmember_page.dart';
import '../after_login/solotte_page.dart';
import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);

    final phoneNumber = ref.watch(phoneNumberProvider);
    final passWord = ref.watch(passWordProvider);
    final hidePassword = useState<bool>(true);

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 70),
                Image.asset('assets/images/1080x384solotte.png'),
                const Text('ログイン',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('電話番号 または 会員ID',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '電話番号または会員IDを入力(ハイフンなし)',
                    border: OutlineInputBorder(),
                  ),
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
                    hintText: 'パスワードを入力',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        hidePassword.value = !hidePassword.value;
                      },
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  obscureText: hidePassword.value,
                  onChanged: (value) {
                    // flutter_hooksが使えるなら、onChangedのところはuseStateで値は渡せる。
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
                            // 不要なprint文は書くべきではない。現場では嫌がられる。
                            // print('ログイン失敗: $e');
                            /// [FirebaseAuthException] は、error messageを出さないなら書く必要ない!
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'ログイン失敗: ${e.message}',
                                ),
                              ),
                            );
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
                  child: const Text(
                    'パスワードを忘れてしまった場合',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
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
      ),
    );
  }
}
