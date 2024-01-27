int birthdayToAge(DateTime birthday) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthday.year;
  if (currentDate.month < birthday.month ||
      (currentDate.month == birthday.month && currentDate.day < birthday.day)) {
    age--;
  }
  return age;
}