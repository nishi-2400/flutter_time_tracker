import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign_in/sign_in_page.dart';
import 'home_page.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // 監視するのストリームをセット(ログイン状況をListenするFirebaseのStream)
      stream: widget.auth.authStateChanges(),
      // snapshot : イベントにより送信されたデータ関連のプロパティを
      builder: (context, snapshot) {
        // connectionState : 通信状況を取得
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          print(user?.uid);
          if (user == null) {
            return SignInPage(
              auth: widget.auth,
              onSignIn: _updateUser,
            );
          } else {
            return HomePage(
              auth: widget.auth,
              onSignOut: () => _updateUser(null),
            );
          }
        }
        return Scaffold(
          body: Center(
            // CircularProgressIndicator : 通信中のインジケータを表示
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}
