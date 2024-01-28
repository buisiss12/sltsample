import 'login_page.dart';
import 'resistration_page.dart';
import 'provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class OldMemberPage extends ConsumerWidget {
  const OldMemberPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = ref.watch(genderProvider);
    final birthday = ref.watch(birthdayProvider);
    final birthdayNotifier = ref.read(birthdayProvider.notifier);

    final store = ref.watch(storeProvider);

    Future<void> selectBirthday(BuildContext context) async {
      final DateTime? picked = await DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(1924, 1, 1),
        maxTime: DateTime.now(),
        onChanged: (date) {},
        onConfirm: (date) {
          birthdayNotifier.state = date;
        },
        currentTime: DateTime.now(),
        locale: LocaleType.jp,
      );
      if (picked != null && picked != birthday) {
        birthdayNotifier.state = picked;
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
                  decoration: const InputDecoration(
                    hintText: '会員IDを入力',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    ref.read(userIdProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 16),
                const Text('性別', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gender == 'male' ? Colors.blue : null,
                      ),
                      onPressed: () {
                        ref.read(genderProvider.notifier).state = 'male';
                      },
                      child: const Text('男性'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            gender == 'female' ? Colors.pink : null,
                      ),
                      onPressed: () {
                        ref.read(genderProvider.notifier).state = 'female';
                      },
                      child: const Text('女性'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('生年月日',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => selectBirthday(context),
                  child: Text(
                    birthday != null
                        ? "${birthday.year}/${birthday.month}/${birthday.day}"
                        : '日付を選択',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('登録店舗',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _showPicker(context, ref),
                  child: Text(store),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                /*ElevatedButton(
                  onPressed: _isResistrationButton ? _verifyPhone : null,
                  child: const Text('会員情報を引き継いで登録'),
                ),*/
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

  void _showPicker(BuildContext context, WidgetRef ref) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerData: [
            "ag札幌",
            "ag仙台",
            "ソウル カンナム",
            "ag金沢",
            "宇都宮",
            "大宮",
            "ag上野",
            "上野",
            "新宿",
            "ag渋谷",
            "渋谷本店",
            "渋谷駅前",
            "恵比寿",
            "町田",
            "横浜",
            "静岡",
            "浜松",
            "名古屋 栄",
            "名古屋 錦",
            "ag名古屋",
            "京都",
            "梅田",
            "茶屋町",
            "心斎橋",
            "難波",
            "神戸",
            "岡山",
            "広島",
            "福岡",
            "小倉",
            "熊本",
            "宮崎",
            "鹿児島",
            "ag沖縄"
          ],
        ),
        hideHeader: true,
        title: const Text("店舗を選択"),
        onConfirm: (Picker picker, List value) {
          ref.read(storeProvider.notifier).state =
              picker.getSelectedValues()[0];
        }).showModal(context);
  }
}
