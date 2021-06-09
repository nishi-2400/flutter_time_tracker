import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign_in/social_sing_in_button.dart';
import 'package:flutter_time_tracker/common_widgets/sign_in_button.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  // コンストラクタ
  const SignInPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  // 匿名ログイン
  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  // Googleログイン
  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker App'),
        elevation: 10,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildContent() {
    return Padding(
      // child配下のwidgetのpaddingを指定
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: 'Sign in with Google',
            assetName: 'images/google-logo.png',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          Text(
            'Or',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in anonymously',
            textColor: Colors.white,
            color: Colors.redAccent,
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
