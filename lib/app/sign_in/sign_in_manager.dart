import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class SignInManager {
  SignInManager({ required this.auth, required this.isLoading });
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  // Futureを返すメソッドを引数にセット
  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Futureを返すメソッドを引数にセット
  Future<UserCredential?> _signInGoogle(Future<UserCredential?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
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