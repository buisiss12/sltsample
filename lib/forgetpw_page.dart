import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPwPage extends StatefulWidget {
  const ForgetPwPage({super.key});

  @override
  State<ForgetPwPage> createState() => _ForgetPwPageState();
}

class _ForgetPwPageState extends State<ForgetPwPage> {
  final _memberNumber = TextEditingController();
  final _phoneNumber = TextEditingController();
  bool _isResetPwButton = false; // ボタンの有効状態を追跡

  @override
  void initState() {
    super.initState();
    _memberNumber.addListener(_resetPwButtonState);
    _phoneNumber.addListener(_resetPwButtonState);
  }

  void _resetPwButtonState() {
    setState(() {
      _isResetPwButton =
          _memberNumber.text.isNotEmpty && _phoneNumber.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _memberNumber.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  void _resetPw() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // キーボードを隠す
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('パスワード再設定'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('パスワードを忘れてしまった場合',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('会員IDと電話番号を入力後、電話番号宛に認証番号が送信されます。'),
              const SizedBox(height: 16),
              const Text('会員ID', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _memberNumber,
                decoration: InputDecoration(
                  hintText: '会員IDを入力',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              const Text('電話番号', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                  hintText: '電話番号を入力(ハイフンなし)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              const Text(
                  '*会員IDを忘れた場合や、電話番号を変更された場合はお手数ですがオリエンタルラウンジ・agの店舗スタッフへお問い合わせください。'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isResetPwButton ? _resetPw : null,
                child: const Text('パスワードを再設定する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
