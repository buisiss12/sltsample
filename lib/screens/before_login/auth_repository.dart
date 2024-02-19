import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

// メールアドレス・パスワードについてのドキュメント
// https://firebase.google.com/docs/auth/flutter/password-auth?hl=ja

// ログインのロジックのクラス
class AuthRepository {
  final _auth = FirebaseAuth.instance;

  // 新規登録
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // ログイン
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // ログアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }
}