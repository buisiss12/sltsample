import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:sltsampleapp/models/user_state.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

// used in 'login_page.dart' 'resistration.dart'
final phoneNumberProvider = StateProvider.autoDispose<String>((ref) => '');
final passWordProvider = StateProvider.autoDispose<String>((ref) => '');

// used in 'resistration.dart'
final realNameProvider = StateProvider.autoDispose<String>((ref) => '');
final genderProvider = StateProvider.autoDispose<String>((ref) => '');
final birthdayProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

// used in 'forgetpw_page.dart'
final memberNumberProvider = StateProvider.autoDispose<String>((ref) => '');

// used id 'oldmember_resistration_page.dart'
final userIdProvider = StateProvider<String>((ref) => '');
final storeProvider = StateProvider<String>((ref) => '');

final userStateFutureProvider = FutureProvider<List<UserState>>((ref) async {
  final userStateAPI = UserStateAPI(ref);
  return userStateAPI.fetchUsers();
});

final userStateAPIProvider = Provider<UserStateAPI>((ref) => UserStateAPI(ref));

class UserStateAPI {
  UserStateAPI(this.ref);
  final Ref ref;

  Future<void> createUser(UserState userState) async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      await ref
          .read(firebaseFirestoreProvider)
          .collection('users')
          .doc(user.uid)
          .set(userState.toJson(),
              SetOptions(merge: true)); //指定したフィールドのみを更新または追加するoption
    }
  }

  Future<List<UserState>> fetchUsers() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      // 現在のユーザーのデータのみを取得
      final snapshot = await ref
          .read(firebaseFirestoreProvider)
          .collection('users')
          .doc(user.uid)
          .get();
      return [UserState.fromJson(snapshot.data()!)];
    } else {
      return [];
    }
  }
}

final postsStreamProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  });
});

final selectedProfileImageProvider = StateProvider<File?>((ref) => null);
