import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// used in 'addpost_page.dart'
final addPostProvider = StateProvider.autoDispose<String>((ref) => '');
final areaProvider = StateProvider.autoDispose<List<String>>((ref) => []);

// used in 'login_page.dart' 'resistration.dart'
final phoneNumberProvider = StateProvider.autoDispose<String>((ref) => '');
final passWordProvider = StateProvider.autoDispose<String>((ref) => '');
final hidePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);

// used in 'resistration.dart'
final realNameProvider = StateProvider.autoDispose<String>((ref) => '');
final genderProvider = StateProvider.autoDispose<String>((ref) => '');
final birthdayProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

// used in 'forgetpw_page.dart' ''
final memberNumberProvider = StateProvider.autoDispose<String>((ref) => '');

final userProfileProvider =
    FutureProvider.autoDispose<DocumentSnapshot>((ref) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('ユーザーがログインしていません');
  }
  return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
});
