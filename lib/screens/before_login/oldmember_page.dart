import 'package:flutter_hooks/flutter_hooks.dart';

import 'login_page.dart';
import 'registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// このページは現在ロジックは未実装、UIのみ実装

class OldMemberPage extends HookConsumerWidget {
  const OldMemberPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = useState<String>('');

    //final store = ref.watch(storeProvider);

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('以前会員登録した方'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('会員ID(数字４桁以上)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
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
                const Text('生年月日',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // ElevatedButton(
                //   onPressed: () =>
                //       Utility.selectBirthday(context, birthdayNotifier),
                //   child: Text(
                //     birthday != null
                //         ? "${birthday.year}/${birthday.month}/${birthday.day}"
                //         : '日付を選択',
                //   ),
                // ),
                const SizedBox(height: 16),
                const Text('登録店舗',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // ElevatedButton(
                //   onPressed: () => _selectStorePicker(context, ref),
                //   child: Text(store),
                // ),
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

  // void _selectStorePicker(BuildContext context, WidgetRef ref) {
  //   Picker(
  //       adapter: PickerDataAdapter<String>(
  //         pickerData: [
  //           "ag札幌",
  //           "ag仙台",
  //           "ソウル カンナム",
  //           "ag金沢",
  //           "宇都宮",
  //           "大宮",
  //           "ag上野",
  //           "上野",
  //           "新宿",
  //           "ag渋谷",
  //           "渋谷本店",
  //           "渋谷駅前",
  //           "恵比寿",
  //           "町田",
  //           "横浜",
  //           "静岡",
  //           "浜松",
  //           "名古屋 栄",
  //           "名古屋 錦",
  //           "ag名古屋",
  //           "京都",
  //           "梅田",
  //           "茶屋町",
  //           "心斎橋",
  //           "難波",
  //           "神戸",
  //           "岡山",
  //           "広島",
  //           "福岡",
  //           "小倉",
  //           "熊本",
  //           "宮崎",
  //           "鹿児島",
  //           "ag沖縄"
  //         ],
  //       ),
  //       hideHeader: true,
  //       title: const Text("店舗を選択"),
  //       onConfirm: (Picker picker, List value) {
  //         ref.read(storeProvider.notifier).state =
  //             picker.getSelectedValues()[0];
  //       }).showModal(context);
  // }
}
