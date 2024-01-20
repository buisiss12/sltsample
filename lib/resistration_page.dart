// ignore_for_file: avoid_print

import 'solotte_page.dart';
import 'login_page.dart';
import 'oldmember_resistration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _auth = FirebaseAuth.instance;
  final _realNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _passWord = TextEditingController();

  bool _hidePassword = true;
  bool _isResistrationButton = false;
  DateTime? _selectedBirthDay;

  @override
  void initState() {
    super.initState();
    _realNameController.addListener(_resistrationButtonState);
    _genderController.addListener(_resistrationButtonState);
    _birthdayController.addListener(_resistrationButtonState);
    _phoneNumber.addListener(_resistrationButtonState);
    _passWord.addListener(_resistrationButtonState);
  }

  @override
  void dispose() {
    _realNameController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();
    _phoneNumber.dispose();
    _passWord.dispose();
    super.dispose();
  }

  void _resistrationButtonState() {
    setState(() {
      _isResistrationButton = _realNameController.text.isNotEmpty &&
          _genderController.text.isNotEmpty &&
          _birthdayController.text.isNotEmpty &&
          _phoneNumber.text.isNotEmpty &&
          _passWord.text.isNotEmpty;
    });
  }

  Future<void> _verifySms() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+81${_phoneNumber.text}",
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
        await _auth.signInWithCredential(credential); //電話番号として登録
        try {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            //メールアドレスとして登録
            email: "${_phoneNumber.text}@test.com",
            password: _passWord.text,
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            '本名': _realNameController.text,
            '性別': _genderController.text,
            '生年月日': _birthdayController.text,
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SolottePage()),
            (Route<dynamic> route) => false,
          );
        } on FirebaseAuthException catch (e) {
          print('登録失敗: $e');
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  String _selectedGender = '';
  void _setGender(String gender) {
    setState(() {
      _selectedGender = gender;
      _genderController.text = gender;
    });
  }

  void _setBirthday(DateTime date) {
    setState(() {
      _selectedBirthDay = date;
      _birthdayController.text = "${date.year}-${date.month}-${date.day}";
    });
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
                  controller: _realNameController,
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
                      onPressed: () => _setGender('男性'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedGender == '男性' ? Colors.blue : null,
                      ),
                      child: const Text('男性'),
                    ),
                    ElevatedButton(
                      onPressed: () => _setGender('女性'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedGender == '女性' ? Colors.pink : null,
                      ),
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
                        _setBirthday(date);
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
