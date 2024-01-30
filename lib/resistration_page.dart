// ignore_for_file: avoid_print

import 'login_page.dart';
import 'oldmember_resistration_page.dart';
import 'solotte_page.dart';
import 'models/user_model.dart';
import 'provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends ConsumerWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final firestore = ref.watch(firestoreProvider);

    final phoneNumber = ref.watch(phoneNumberProvider);
    final passWord = ref.watch(passWordProvider);
    final hidePassword = ref.watch(hidePasswordProvider);
    final realName = ref.watch(realNameProvider);
    final gender = ref.watch(genderProvider);
    final birthday = ref.watch(birthdayProvider);
    final birthdayNotifier = ref.read(birthdayProvider.notifier);

    Future<void> verifySms() async {
      await auth.verifyPhoneNumber(
        phoneNumber: "+81$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        //iOSの場合resendTokenは常にnull
        codeSent: (String verificationId, int? resendToken) async {
          String smsCode = '';
          await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("認証コード"),
                content: const Text("SMS宛に届いた認証コードを入力してください"),
                actions: <Widget>[
                  TextFormField(
                    onChanged: (value) {
                      smsCode = value;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  ElevatedButton(
                    child: const Text("認証"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          await auth.signInWithCredential(credential); //電話番号として登録
          try {
            UserCredential userCredential =
                await auth.createUserWithEmailAndPassword(
              //メールアドレスとして登録
              email: "$phoneNumber@test.com",
              password: passWord,
            );
            await firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
              'ニックネーム': '',
              '本名': realName,
              '性別': gender,
              '生年月日': birthday,
              '居住地': '',
              '希望地域': '',
              'profileImageUrl': '',
            });
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SolottePage()),
                (Route<dynamic> route) => false,
              );
            }
          } on FirebaseAuthException catch (e) {
            print('登録失敗: $e');
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // キーボードを隠す
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新規会員登録'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('本名フルネーム(ひらがな)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '本名をフルネームで入力(ひらがな)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    ref.read(realNameProvider.notifier).state = value;
                  },
                ),
                const Text('*店舗での本人確認にのみ使用いたします。第三者には公開されません。'),
                const SizedBox(height: 16),
                const Text('性別', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gender == 'male' ? Colors.blue : null,
                      ),
                      onPressed: () {
                        ref.read(genderProvider.notifier).state = 'male';
                      },
                      child: const Text('男性'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            gender == 'female' ? Colors.pink : null,
                      ),
                      onPressed: () {
                        ref.read(genderProvider.notifier).state = 'female';
                      },
                      child: const Text('女性'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('生年月日',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () =>
                      Models.selectBirthday(context, birthdayNotifier),
                  child: Text(
                    birthday != null
                        ? "${birthday.year}/${birthday.month}/${birthday.day}"
                        : '日付を選択',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('電話番号',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '電話番号を入力(ハイフンなし)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    ref.read(phoneNumberProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 16),
                const Text('パスワード(数字6桁以上)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'パスワードを入力',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
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
                const Text('*オリエンタルラウンジ・ag入店時に身分証を確認させていただきます'),
                const SizedBox(height: 16),
                const Text('*「会員登録」のボタンを押すことにより、利用規約に同意したものとみなします。'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: realName.isNotEmpty &&
                          gender.isNotEmpty &&
                          birthday != null &&
                          phoneNumber.isNotEmpty &&
                          passWord.isNotEmpty
                      ? verifySms
                      : null,
                  child: const Text('会員登録'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('ログイン'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
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
