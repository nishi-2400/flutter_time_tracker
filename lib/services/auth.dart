import 'package:firebase_auth/firebase_auth.dart';

// 認証用のabstractクラス
abstract class AuthBase {
  // ログイン中のユーザの情報
  User? get currentUser;
  // 匿名ログイン用
  Future<User?> signInAnonymously();
  // ログアウト
  Future<void> signOut();
}

// FireBaseを使った処理を実装
class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }
  @override
  Future<void> signOut() async {
   await _firebaseAuth.signOut();
  }
}