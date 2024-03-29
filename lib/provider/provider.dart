import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Project imports:
import 'package:sltsampleapp/models/recent_message_model.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:sltsampleapp/models/user_model.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

final userStateFutureProvider = FutureProvider<List<UserModel>>((ref) async {
  final userStateAPI = UserStateAPI(ref);
  return userStateAPI.getUsers();
});

final userStateAPIProvider = Provider<UserStateAPI>((ref) => UserStateAPI(ref));

class UserStateAPI {
  UserStateAPI(this.ref);
  final Ref ref; // ここに、refつけないと、メソッドでfireStoreProviderを参照できない

  Future<void> setUser(UserModel userState) async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      await ref
          .read(firebaseFirestoreProvider)
          .collection('users')
          .doc(user.uid)
          .set(
            userState.toJson(),
            SetOptions(merge: true),
          ); //指定したフィールドのみを更新または追加するoption
    }
  }

  Future<List<UserModel>> getUsers() async {
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

  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final querySnapshot = await ref
        .read(firebaseFirestoreProvider)
        .collection('users')
        .where('userPhoneNumber', isEqualTo: phoneNumber)
        .get();
    return querySnapshot.docs.isNotEmpty; // 同一の電話番号があればtrue、なければfalseを返す
  }
}

final getPostedUserUidProvider =
    FutureProvider.family<UserModel, String>((ref, postedUserUid) async {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final snapshot = await firestore.collection('users').doc(postedUserUid).get();
  return UserModel.fromJson(snapshot.data() ?? {});
});

final getUserUidProvider =
    FutureProvider.family<UserModel, String>((ref, userUid) async {
  final firestore = ref.read(firebaseFirestoreProvider);
  final snapshot = await firestore.collection('users').doc(userUid).get();
  if (snapshot.exists) {
    return UserModel.fromJson(snapshot.data()!);
  }
  throw Exception("User not found");
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

final messageStreamProvider =
    StreamProvider.family<List<RecentMessageModel>, String>((ref, userUid) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection('conversations')
      .where('userUid', arrayContains: userUid)
      .orderBy('lastMessageTimestamp', descending: true)
      .snapshots()
      .map(
    (snapshot) {
      return snapshot.docs
          .map((doc) => RecentMessageModel.fromJson(doc.data()))
          .toList();
    },
  );
});
