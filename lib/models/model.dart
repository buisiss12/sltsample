import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class Logics {
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
