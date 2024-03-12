import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/screens/home.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'registration_page.dart';
import '../../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final Utility utility = Utility();
  String phoneNumber = '';

  Future<void> verifyPhoneSMSforLogin() async {
    final usersCollection =
        ref.read(firebaseFirestoreProvider).collection('users');
    final querySnapshot = await usersCollection
        .where('userPhoneNumber', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      if (mounted) {
        utility.showSnackBarAPI(context, 'この電話番号は既に登録されています。');
      }
      return;
    }
    await ref.read(firebaseAuthProvider).verifyPhoneNumber(
          phoneNumber: "+81$phoneNumber",
          verificationCompleted: (PhoneAuthCredential credential) async {
            await signInAndRedirectForLogin(credential);
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
              await signInAndRedirectForLogin(credential);
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
  }

  Future<void> signInAndRedirectForLogin(PhoneAuthCredential credential) async {
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
                Image.asset('assets/images/1080x384solotte.png'),
                const Text(
                  'ログイン',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  '電話番号 または 会員ID',
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
                          verifyPhoneSMSforLogin();
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
