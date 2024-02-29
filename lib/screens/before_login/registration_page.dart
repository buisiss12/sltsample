import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sltsampleapp/models/user_model.dart';
import 'package:sltsampleapp/screens/home_widget/home_page.dart';
import 'login_page.dart';
import 'oldmember_page.dart';
import '../../utils/utility.dart';
import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends HookConsumerWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);

    final phoneNumber = useState<String>('');
    final passWord = useState<String>('');
    final hidePassword = useState<bool>(true);
    final realName = useState<String>('');
    final gender = useState<String>('');
    final birthDay = useState<DateTime?>(null);

    Future<void> registration() async {
      await auth.verifyPhoneNumber(
        phoneNumber: "+81${phoneNumber.value}",
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          Utility.showSnackBarAPI(context, '認証に失敗しました: ${e.message}');
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
                    onChanged: (value) => smsCode = value,
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

          try {
            //電話番号認証:現状ログイン時は"新規会員登録"ページから上書きという形になっている。
            final credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);
            await auth.signInWithCredential(credential);

            //*非推奨:電話番号+パスワードで登録する際は下記コードも加える。（電話番号をメールアドレスとして登録、Authには電話番号認証、メール認証の二つのアカウントが作成される。ユーザーの識別"UID"は全て後者で管理される)　一応動く
            // await auth.createUserWithEmailAndPassword(
            //   email: "${phoneNumber.value}@test.com",
            //   password: passWord.value,
            // );

            final userModel = UserModel(
              userUid: auth.currentUser!.uid,
              profileImageUrl: '',
              realName: realName.value,
              nickName: '',
              gender: gender.value,
              birthday: birthDay.value!,
              height: '',
              job: '',
              residence: '',
            );
            await ref.read(userStateAPIProvider).createUser(userModel);

            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            }
          } on FirebaseAuthException catch (e) {
            if (context.mounted) {
              Utility.showSnackBarAPI(context, 'アカウント作成に失敗しました: ${e.message}');
            }
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }

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
                  onChanged: (value) => realName.value = value,
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
                        backgroundColor:
                            gender.value == '男性' ? Colors.blue : null,
                      ),
                      onPressed: () => gender.value = '男性',
                      child: const Text('男性'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            gender.value == '女性' ? Colors.pink : null,
                      ),
                      onPressed: () => gender.value = '女性',
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
                      (date) => birthDay.value = date,
                    );
                  },
                  child: Text(
                    birthDay.value != null
                        ? "${birthDay.value!.year}年${birthDay.value!.month}月${birthDay.value!.day}日"
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
                  onChanged: (value) => phoneNumber.value = value,
                ),
                const SizedBox(height: 16),
                const Text(
                  'パスワード(数字6桁以上)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                      onPressed: () => hidePassword.value = !hidePassword.value,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  obscureText: hidePassword.value,
                  onChanged: (value) => passWord.value = value,
                ),
                const SizedBox(height: 16),
                const Text('*オリエンタルラウンジ・ag入店時に身分証を確認させていただきます'),
                const SizedBox(height: 16),
                const Text('*「会員登録」のボタンを押すことにより、利用規約に同意したものとみなします。'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: realName.value.isNotEmpty &&
                          gender.value.isNotEmpty &&
                          birthDay.value != null &&
                          phoneNumber.value.isNotEmpty &&
                          passWord.value.isNotEmpty
                      ? registration
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OldMemberPage(),
                      ),
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
