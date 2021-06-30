import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class JobPage extends StatelessWidget {
  // Logout
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // サインアウトの確認ダイアログ
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to sign out?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    );

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    );
  }

  Future<void> _createJob(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    database.createJob(Job(name: 'Blogging', ratePerHour: 10));
  }
}
