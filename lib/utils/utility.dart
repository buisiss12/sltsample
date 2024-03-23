import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class Utility {
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

  static const List<String> shops = [
    'ag札幌',
    'ag仙台',
    'ソウル カンナム',
    'ag金沢',
    '宇都宮',
    '大宮',
    'ag上野',
    '上野',
    '新宿',
    'ag渋谷',
    '渋谷本店',
    '渋谷駅前',
    '恵比寿',
    '町田',
    '横浜',
    '静岡',
    '浜松',
    '名古屋 栄',
    '名古屋 錦',
    'ag名古屋',
    '京都',
    '梅田',
    '茶屋町',
    '心斎橋',
    '難波',
    '神戸',
    '岡山',
    '広島',
    '福岡',
    '小倉',
    '熊本',
    '宮崎',
    '鹿児島',
    'ag沖縄'
  ];

  static String dateTimeConverter(DateTime postTime) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(postTime);

    if (difference.inMinutes < 1) {
      return 'たった今';
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

  Future<String?> showSMSCodeDialog(BuildContext context) async {
    String? smsCode;
    await showDialog(
      context: context,
      builder: (context) {
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
              autofocus: true,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("認証"),
            ),
          ],
        );
      },
    );
    return smsCode;
  }

  static void selectSinglePrefectureDialog(
    BuildContext context,
    TextEditingController residenceController,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('都道府県を選択'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Utility.prefecture.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(Utility.prefecture[index]),
                  onTap: () {
                    residenceController.text = Utility.prefecture[index];
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showDatePicker(BuildContext context, ValueChanged<DateTime> onConfirm) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      onConfirm: onConfirm,
      currentTime: DateTime.now(),
      locale: LocaleType.jp,
    );
  }

  int birthdayToAgeConverter(DateTime birthday) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    if (currentDate.month < birthday.month ||
        (currentDate.month == birthday.month &&
            currentDate.day < birthday.day)) {
      age--;
    }
    return age;
  }

  void showSnackBarAPI(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> showDialogAPI(BuildContext context, String title,
      String content, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(content)]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static String regularRank = ("チャージ無料");
  static String rubyRank = ("最初の30分無料(20時までに入店された方&2名以上)");
  static String sapphireRank =
      ("平日VIP ROOM半額\n*予約、お部屋の指定は不可\n*シャンパン等のサービス品提供は一切ございません\n*一般席への途中移動をお願いする可能性がございます");
  static String diamondRank =
      ("毎日22時までVIP ROOM無料\n*予約、お部屋の指定は不可\n*シャンパン等のサービス品提供は一切ございません\n*一般席への途中移動をお願いする可能性がございます");

  String getMemberTitle(int index) {
    switch (index) {
      case 0:
        return "グリーン会員";
      case 1:
        return "ゴールド会員";
      case 2:
        return "プラチナ会員";
      default:
        return "グリーン会員";
    }
  }

  Color getMemberColor(int index) {
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.grey;
      default:
        return Colors.lightGreen;
    }
  }

  List<String> getMemberBenefits(int index) {
    final green = [
      '毎日21時まで「1時間相席(料金)が無料」',
      '全国全店舗でご利用可能(1日1店舗目にご来店した店舗のみ)',
      '昼営業「1時間相席料金が半額」',
    ];
    final gold = [
      '毎日いつでも「1時間相席(料金)が無料」',
      '全国全店舗でご利用可能(1日1店舗目にご来店した店舗のみ)',
      '昼営業「1時間相席料金が半額」',
    ];
    final platinum = [
      '毎日いつでも「時間無制限 相席料金が無料」',
      '全国全店舗でご利用可能(1日複数店舗可)',
      '昼営業「無制限 相席料金が半額」',
      'オリエンタルラウンジ・ag 行き放題サービス',
      '混雑時、優先入店',
    ];

    switch (index) {
      case 0:
        return green;
      case 1:
        return gold;
      case 2:
        return platinum;
      default:
        return green;
    }
  }

  static List<HonorData> getHonorDataList() {
    return [
      HonorData(title: '初回来店', currentValue: 1, maxValue: 1),
      HonorData(title: '3回来店', currentValue: 1, maxValue: 3),
      HonorData(title: '5回来店', currentValue: 1, maxValue: 5),
      HonorData(title: '2店舗はしご', currentValue: 0, maxValue: 1),
      HonorData(title: '3店舗はしご', currentValue: 0, maxValue: 2),
      HonorData(title: '4店舗はしご', currentValue: 0, maxValue: 3),
      HonorData(title: 'VIP利用5回', currentValue: 1, maxValue: 5),
      HonorData(title: 'VIP利用10回', currentValue: 1, maxValue: 10),
      HonorData(title: '連続ログイン3日', currentValue: 3, maxValue: 3),
      HonorData(title: '連続ログイン5日', currentValue: 3, maxValue: 5),
      HonorData(title: '連続ログイン10日', currentValue: 3, maxValue: 10),
    ];
  }
}

class HonorData {
  final String title;
  final int currentValue;
  final int maxValue;

  HonorData(
      {required this.title,
      required this.currentValue,
      required this.maxValue});
}
