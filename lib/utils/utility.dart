import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class Utility {
  //todohukenはやめた方が良い。英語のprefectureに変更する
  static const List<String> prefecture = [
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県',
  ];
  // lowerCamelCaseに変更する。(単語の先頭を大文字にしてつなげる表記方法)
  static Future<void> selectPrefectureDialog(BuildContext context,
      ValueNotifier<List<String>> selectedPrefecture) async {
    final List<String> selectedValues = List.from(selectedPrefecture.value);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('都道府県を選択'),
          content: SingleChildScrollView(
            child: ListBody(
              children: prefecture.map((String prefecture) {
                return CheckboxListTile(
                  value: selectedValues.contains(prefecture),
                  title: Text(prefecture),
                  onChanged: (bool? value) {
                    if (value == true) {
                      if (!selectedValues.contains(prefecture)) {
                        selectedValues.add(prefecture);
                      }
                    } else {
                      selectedValues.remove(prefecture);
                    }
                    (context as Element).markNeedsBuild();
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("キャンセル"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                selectedPrefecture.value = selectedValues;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> selectBirthday(
      BuildContext context, StateController<DateTime?> birthdayNotifier) async {
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
    if (picked != null && picked != birthdayNotifier.state) {
      birthdayNotifier.state = picked;
    }
  }

  static birthdayToAge(DateTime birthday) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    if (currentDate.month < birthday.month ||
        (currentDate.month == birthday.month &&
            currentDate.day < birthday.day)) {
      age--;
    }
    return age;
  }
}
// lowerCamelCaseに変更した。
String dateTimeConverter(DateTime postTime) {
  final currentTime = DateTime.now();
  final difference = currentTime.difference(postTime);

  if (difference.inMinutes < 1) {
    return 'ちょうど今';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}分前';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}時間前';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}日前';
  } else {
    return '${postTime.year}/${postTime.month}/${postTime.day}';
  }
}
