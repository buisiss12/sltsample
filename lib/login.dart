// ignore_for_file: avoid_print

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
  bool _isButtonEnabled = false; // ボタンの有効状態を追跡

  @override
  void initState() {
    super.initState();
    _phoneNumber.addListener(_updateButtonState);
    _passWord.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
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
    // ログインロジックを実装
    print('電話番号: ${_phoneNumber.text}, パスワード: ${_passWord.text}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // キーボードを隠す
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Image.asset('assets/images/1080x384solotte.png',
                    fit: BoxFit.cover),
              ),
              const Text('ログイン',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('電話番号 または 会員ID'),
              TextField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                  hintText: '電話番号または会員IDを入力',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              const Text('パスワード (数字6桁以上)'),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _login : null,
                child: const Text('ログイン'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('パスワードを忘れてしまった場合'),
              ),
              ElevatedButton(
                onPressed: () {},
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
