import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/home_page.dart';
import 'package:flutter_time_tracker/app/sign_in/sign_in_page.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      // 監視するのストリームをセット(ログイン状況をListenするFirebaseのStream)
      stream: auth.authStateChanges(),
      // snapshot : イベントにより送信されたデータ関連のプロパティを
      builder: (context, snapshot) {
        // connectionState : 通信状況を取得
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          final userId = user?.uid;
          print('user:$userId');
          if (user == null) {
            // サインイン関連の状態を管理するProviderを生成
            return SignInPage.create(context);
          } else {
            // Jobsページの親としてProviderをセット
            return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage()
            );
          }
        }
        return Scaffold(
          body: Center(
            // CircularProgressIndicator : 通信中のインジケータを表示
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
