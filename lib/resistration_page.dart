// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _phoneNumber = TextEditingController();
  final _passWord = TextEditingController();
  bool _hidePassword = true;
  bool _isResistrationButton = false;

  @override
  void initState() {
    super.initState();
    _phoneNumber.addListener(_resistrationButtonState);
    _passWord.addListener(_resistrationButtonState);
  }

  void _resistrationButtonState() {
    setState(() {
      _isResistrationButton =
          _phoneNumber.text.isNotEmpty && _passWord.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _phoneNumber.dispose();
    _passWord.dispose();
    super.dispose();
  }

  void _register() {
    print('電話番号: ${_phoneNumber.text}, パスワード: ${_passWord.text}');
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('電話番号', style: TextStyle(fontWeight: FontWeight.bold)),
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
              const Text('パスワード (数字6桁以上)',
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isResistrationButton ? _register : null,
                child: const Text('会員登録'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
