import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sltsampleapp/models/recent_message_model.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:sltsampleapp/models/user_model.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

final userStateFutureProvider = FutureProvider<List<UserModel>>((ref) async {
  final userStateAPI = UserStateAPI(ref);
  return userStateAPI.fetchUsers();
});

final userStateAPIProvider = Provider<UserStateAPI>((ref) => UserStateAPI(ref));

class UserStateAPI {
  UserStateAPI(this.ref);
  final Ref ref;

  Future<void> createUser(UserModel userState) async {
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

  Future<List<UserModel>> fetchUsers() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      // 現在のユーザーのデータのみを取得
      final snapshot = await ref
          .read(firebaseFirestoreProvider)
          .collection('users')
          .doc(user.uid)
          .get();
      return [UserModel.fromJson(snapshot.data()!)];
    } else {
      return [];
    }
  }
}

final getPostedUserUidProvider =
    FutureProvider.family<UserModel, String>((ref, postedUserUid) async {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final snapshot = await firestore.collection('users').doc(postedUserUid).get();
  return UserModel.fromJson(snapshot.data() ?? {});// ! -> ?? {}に変更
});

final postsStreamProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(
    (snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
    },
  );
});

final selectedProfileImageProvider = StateProvider<File?>((ref) => null);

final messageStreamProvider =
    StreamProvider.family<List<RecentMessageModel>, String>((ref, userUid) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection('conversations')
      .where('userUid', arrayContains: userUid)
      .snapshots()
      .map(
    (snapshot) {
      return snapshot.docs
          .map((doc) => RecentMessageModel.fromJson(doc.data()))
          .toList();
    },
  );
});

final userDetailProvider =
    FutureProvider.family<UserModel, String>((ref, userUid) async {
  final firestore = ref.read(firebaseFirestoreProvider);
  final docSnapshot = await firestore.collection('users').doc(userUid).get();
  if (docSnapshot.exists) {
    return UserModel.fromJson(docSnapshot.data()!);
  }
  throw Exception("User not found");
});
