import 'package:sltsampleapp/models/user_model.dart';
import 'package:sltsampleapp/screens/home.dart';
import 'login_page.dart';
import '../../../utils/utility.dart';
import '../../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final utility = Utility();

  String phoneNumber = '';
  String realName = '';
  String gender = '';
  DateTime? birthDay;

  Future<void> verifyPhoneSMS() async {
    await ref.read(firebaseAuthProvider).verifyPhoneNumber(
          phoneNumber: "+81$phoneNumber",
          verificationCompleted: (PhoneAuthCredential credential) async {
            await signInAndRedirect(credential);
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
              await signInAndRedirect(credential);
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
  }

  Future<void> signInAndRedirect(PhoneAuthCredential credential) async {
    try {
      final userCredential =
          await ref.read(firebaseAuthProvider).signInWithCredential(credential);
      if (userCredential.user == null) {
        if (mounted) {
          utility.showSnackBarAPI(context, 'ログイン失敗');
        }
        return;
      }
      final userModel = UserModel(
        userUid: userCredential.user!.uid,
        profileImageUrl: '',
        realName: realName,
        nickName: '',
        gender: gender,
        birthday: birthDay!,
        height: '',
        job: '',
        residence: '',
      );
      await ref.read(userStateAPIProvider).createUser(userModel);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
        utility.showSnackBarAPI(context, 'アカウント作成成功');
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
        appBar: AppBar(title: const Text('新規会員登録')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '本名フルネーム(ひらがな)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '本名をフルネームで入力(ひらがな)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    setState(() {
                      realName = value;
                    });
                  },
                ),
                const Text('*店舗での本人確認にのみ使用いたします。第三者には公開されません。'),
                const SizedBox(height: 16),
                const Text(
                  '性別',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gender == '男性' ? Colors.blue : null,
                      ),
                      onPressed: () {
                        setState(() {
                          gender = '男性';
                        });
                      },
                      child: const Text('男性'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gender == '女性' ? Colors.pink : null,
                      ),
                      onPressed: () {
                        setState(() {
                          gender = '女性';
                        });
                      },
                      child: const Text('女性'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '生年月日',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Utility().showDatePicker(
                      context,
                      (date) {
                        setState(() {
                          birthDay = date;
                        });
                      },
                    );
                  },
                  child: Text(
                    birthDay != null
                        ? "${birthDay?.year}年${birthDay?.month}月${birthDay?.day}日"
                        : "日付を選択",
                  ),
                ),
                const SizedBox(height: 16),
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
                const Text('*オリエンタルラウンジ・ag入店時に身分証を確認させていただきます'),
                const SizedBox(height: 16),
                const Text('*「会員登録」のボタンを押すことにより、利用規約に同意したものとみなします。'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: realName.isNotEmpty &&
                          gender.isNotEmpty &&
                          birthDay != null &&
                          phoneNumber.isNotEmpty
                      ? verifyPhoneSMS
                      : null,
                  child: const Text('会員登録'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('ログイン'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
