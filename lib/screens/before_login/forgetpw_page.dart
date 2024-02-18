import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgetPwPage extends ConsumerWidget {
  const ForgetPwPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
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
                decoration: const InputDecoration(
                  hintText: '会員IDを入力',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  ref.read(memberNumberProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 16),
              const Text('電話番号', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: const InputDecoration(
                  hintText: '電話番号を入力(ハイフンなし)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  ref.read(phoneNumberProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                  '*会員IDを忘れた場合や、電話番号を変更された場合はお手数ですがオリエンタルラウンジ・agの店舗スタッフへお問い合わせください。'),
              const SizedBox(height: 16),
              /*ElevatedButton(
                onPressed: memberNumber.isNotEmpty && phoneNumber.isNotEmpty ? _resetPw : null,
                child: const Text('パスワードを再設定する'),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
