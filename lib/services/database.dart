import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/services/api_path.dart';
import 'package:flutter_time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job?>> jobsStream();
}

// DateTime型をキャスト
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: ApiPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) => _service.deleteData(path: ApiPath.job(uid, job.id));

  //Job一覧データ
  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
