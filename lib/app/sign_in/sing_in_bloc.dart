import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class SignInBloc {
  SignInBloc({ required this.auth });
  final AuthBase auth;
  // Booleanを受け付けるStreamを定義
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  // Futureを返すメソッドを引数にセット
  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  // Futureを返すメソッドを引数にセット
  Future<UserCredential?> _signInGoogle(Future<UserCredential?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  // 匿名ログイン用
  Future<User?> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  // Googleログイン
  Future<UserCredential?> signInWithGoogle() async => await _signInGoogle(auth.signInWithGoogle);

  // Facebookログイン
  Future<User?> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);
}