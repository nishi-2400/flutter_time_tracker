import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 認証用のabstractクラス
abstract class AuthBase {
  // ログイン中のユーザの情報
  User? get currentUser;

  // 匿名ログイン用
  Future<User?> signInAnonymously();

  // Googleログイン
  Future<UserCredential?> signInWithGoogle();

  // Facebookログイン
  Future<User?> signInWithFacebook();

  //Emailログイン
  Future<User?> signInWithEmail(String email, String password);

  // ログアウト
  Future<void> signOut();

  Future<User?> createUserWithEmailAndPassword(String email, String password);

  // ログイン状態を管理するストリーム
  Stream<User?> authStateChanges();
}

// FireBaseを使った処理を実装
class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  // 匿名ログイン
  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  // Emailログイン
  Future<User?> signInWithEmail(String email, String password) async {
    final userCredentials = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredentials.user;
  }

  // Googleログイン
  @override
  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredentials = _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return userCredentials;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing google id token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  // Facebookログイン
  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredentials = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredentials.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing google id token',
        );
    }
  }

  //　アカウント登録
  @override
  Future<User?> createUserWithEmailAndPassword(String email,
      String password) async {
    final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredentials.user;
  }

  @override
  Future<void> signOut() async {
    // Googleログアウト
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    // Facebookログアウト
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    await _firebaseAuth.signOut();
  }
}
