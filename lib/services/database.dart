import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/services/api_path.dart';

abstract class Database {
  // Job登録
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) => _setData(
    path: ApiPath.job(uid, 'job_abc'),
    data: job.toMap(),
  );

  Future<void> _setData({String? path, Map<String, dynamic>? data}) async {
    final reference = FirebaseFirestore.instance.doc(path!);
    print('$path: $data');
    await reference.set(data!);
  }
}
