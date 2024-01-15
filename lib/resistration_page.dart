// ignore_for_file: avoid_print

import 'login_page.dart';
import 'oldmember_resistration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _userName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _passWord = TextEditingController();
  bool _hidePassword = true;
  bool _isResistrationButton = false;
  DateTime? _selectedBirthDay;

  @override
  void initState() {
    super.initState();
    _userName.addListener(_resistrationButtonState);
    _phoneNumber.addListener(_resistrationButtonState);
    _passWord.addListener(_resistrationButtonState);
  }

  void _resistrationButtonState() {
    setState(() {
      _isResistrationButton = _userName.text.isNotEmpty &&
          _phoneNumber.text.isNotEmpty &&
          _passWord.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _userName.dispose();
    _phoneNumber.dispose();
    _passWord.dispose();
    super.dispose();
  }

  Future<void> _verifySms() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: '+81${_phoneNumber.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('電話番号が正しくありません。');
        }
      },
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
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: _userName,
                  decoration: const InputDecoration(
                    hintText: '本名をフルネームで入力(ひらがな)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
                const Text('*店舗での本人確認にのみ使用いたします。第三者には公開されません。'),
                const SizedBox(height: 16),
                const Text('性別', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('男性'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('女性'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('生年月日',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1924, 1, 1),
                          maxTime: DateTime.now(), onConfirm: (date) {
                        setState(() {
                          _selectedBirthDay = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.jp);
                    },
                    child: Text(_selectedBirthDay != null
                        ? "${_selectedBirthDay!.year}-${_selectedBirthDay!.month}-${_selectedBirthDay!.day}"
                        : '生年月日を選択')),
                const SizedBox(height: 16),
                const Text('電話番号',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _phoneNumber,
                  decoration: const InputDecoration(
                    hintText: '電話番号を入力(ハイフンなし)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                const Text('パスワード(数字6桁以上)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _passWord,
                  decoration: InputDecoration(
                    hintText: 'パスワードを入力',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _hidePassword,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                const Text('*オリエンタルラウンジ・ag入店時に身分証を確認させていただきます'),
                const SizedBox(height: 16),
                const Text('*「会員登録」のボタンを押すことにより、利用規約に同意したものとみなします。'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isResistrationButton ? _verifySms : null,
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
