import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:flutter_time_tracker/app/home/jobs/empty_content.dart';
import 'package:flutter_time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:flutter_time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:flutter_time_tracker/common_widgets/show_exception_alert_dialog.dart';
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

  Future<void> _delete(BuildContext context, Job? job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job!);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
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
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditJobPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    // StreamBuilder：stream上にデータが流れる度にウィジェットとリビルドする
    return StreamBuilder<List<Job?>>(
        // stream: 対象のstream
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Job?>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
              key: Key('job-${job?.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                  job: job!, onTap: () => EditJobPage.show(context, job: job)),
            ),
          );
        });
  }
}
