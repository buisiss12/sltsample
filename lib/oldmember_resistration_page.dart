import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'resistration_page.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OldMemberPage extends StatefulWidget {
  const OldMemberPage({super.key});

  @override
  State<OldMemberPage> createState() => _OldMemberPageState();
}

class _OldMemberPageState extends State<OldMemberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _userId = TextEditingController();
  final _phoneNumber = TextEditingController();
  bool _isResistrationButton = false;
  DateTime? _selectedBirthDay;

  @override
  void initState() {
    super.initState();
    _userId.addListener(_resistrationButtonState);
    _phoneNumber.addListener(_resistrationButtonState);
  }

  void _resistrationButtonState() {
    setState(() {
      _isResistrationButton =
          _userId.text.isNotEmpty && _phoneNumber.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _userId.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  Future<void> _verifyPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+81${_phoneNumber.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {},
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
        await _auth.signInWithCredential(credential);
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
          title: const Text('以前会員登録した方'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('会員ID(数字４桁以上)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _phoneNumber,
                  decoration: const InputDecoration(
                    hintText: '会員IDを入力',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
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
                const Text('登録店舗',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isResistrationButton ? _verifyPhone : null,
                  child: const Text('会員情報を引き継いで登録'),
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
                          builder: (context) => const RegistrationPage()),
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
