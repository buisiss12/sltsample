// ignore_for_file: avoid_print

import 'resistration_page.dart';
import 'forgetpw_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneNumber = TextEditingController();
  final _passWord = TextEditingController();
  bool _hidePassword = false;
  bool _isLoginButton = false; // ボタンの有効状態を追跡

  @override
  void initState() {
    super.initState();
    _phoneNumber.addListener(_loginButtonState);
    _passWord.addListener(_loginButtonState);
  }

  void _loginButtonState() {
    setState(() {
      _isLoginButton =
          _phoneNumber.text.isNotEmpty && _passWord.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _phoneNumber.dispose();
    _passWord.dispose();
    super.dispose();
  }

  void _login() {
    print('電話番号: ${_phoneNumber.text}, パスワード: ${_passWord.text}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // キーボードを隠す
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, //キーボードをUIに影響なく表示
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
                controller: _phoneNumber,
                decoration: InputDecoration(
                  hintText: '電話番号または会員IDを入力(ハイフンなし)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              const Text('パスワード (数字6桁以上)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _passWord,
                decoration: InputDecoration(
                  hintText: 'パスワードを入力',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
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
                obscureText: !_hidePassword,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoginButton ? _login : null,
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
                onPressed: () {},
                child: const Text('以前会員登録した方はこちら'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
