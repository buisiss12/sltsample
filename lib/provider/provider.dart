import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sltsampleapp/models/user_model.dart';

final authProvider = Provider((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

// used in 'addpost_page.dart'
final addPostProvider = StateProvider.autoDispose<String>((ref) => '');
final selectedAreaProvider =
    StateProvider.autoDispose<List<String>>((ref) => []);

// used in 'login_page.dart' 'resistration.dart'
final phoneNumberProvider = StateProvider.autoDispose<String>((ref) => '');
final passWordProvider = StateProvider.autoDispose<String>((ref) => '');
final hidePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);

// used in 'resistration.dart'
final realNameProvider = StateProvider.autoDispose<String>((ref) => '');
final genderProvider = StateProvider.autoDispose<String>((ref) => '');
final birthdayProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

// used in 'forgetpw_page.dart'
final memberNumberProvider = StateProvider.autoDispose<String>((ref) => '');

// used id 'oldmember_resistration_page.dart'
final userIdProvider = StateProvider<String>((ref) => '');
final storeProvider = StateProvider<String>((ref) => '');
