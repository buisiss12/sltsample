import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:sltsampleapp/screens/home.dart';
import 'package:sltsampleapp/screens/widget/pages/registration_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/provider/provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final Utility utility = Utility();
  String phoneNumber = '';

  Future<void> verifyPhoneSmsForLogIn() async {
    final isRegistered = await ref
        .read(userStateAPIProvider)
        .isPhoneNumberRegistered(phoneNumber);

    if (isRegistered) {
      await ref.read(firebaseAuthProvider).verifyPhoneNumber(
            phoneNumber: "+81$phoneNumber",
            verificationCompleted: (PhoneAuthCredential credential) async {
              await logIn(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              utility.showSnackBarAPI(context, '認証失敗: ${e.message}');
            },
            codeSent: (String verificationId, int? resendToken) async {
              final String? smsCode = await utility.showSMSCodeDialog(context);
              if (smsCode != null && smsCode.isNotEmpty) {
                final credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: smsCode,
                );
                await logIn(credential);
              }
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
    } else {
      if (mounted) {
        utility.showSnackBarAPI(context, 'この電話番号は登録されていません。');
      }
    }
  }

  Future<void> logIn(PhoneAuthCredential credential) async {
    try {
      final userCredential =
          await ref.read(firebaseAuthProvider).signInWithCredential(credential);
      if (userCredential.user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
          utility.showSnackBarAPI(context, 'ログイン成功');
        }
      } else {
        if (mounted) {
          utility.showSnackBarAPI(context, 'ログイン失敗');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        utility.showSnackBarAPI(context, 'エラー: ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Image.asset('assets/images/1080x384title.png'),
                const Text(
                  'ログイン',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                const Text(
                  '電話番号',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '電話番号を入力(ハイフンなし)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: phoneNumber.isNotEmpty
                      ? () {
                          verifyPhoneSmsForLogIn();
                        }
                      : null,
                  child: const Text('ログイン'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text('新規会員登録'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
