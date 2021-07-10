import 'package:flutter_time_tracker/app/home/models/entry.dart';
import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/services/api_path.dart';
import 'package:flutter_time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
}

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
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: ApiPath.job(uid, job.id));
  }

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
    path: ApiPath.jobs(uid),
    builder: (data, documentId) => Job.fromMap(data, documentId),
  );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
    path: ApiPath.entry(uid, entry.id),
    data: entry.toMap(),
  );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
    path: ApiPath.entry(uid, entry.id),
  );

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: ApiPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}


// import 'package:flutter_time_tracker/app/home/models/job.dart';
// import 'package:flutter_time_tracker/services/api_path.dart';
// import 'package:flutter_time_tracker/services/firestore_service.dart';
//
// abstract class Database {
//   Future<void> setJob(Job job);
//   Future<void> deleteJob(Job job);
//   Stream<List<Job?>> jobsStream();
// }
//
// // DateTime型をキャスト
// String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
//
// class FirestoreDatabase implements Database {
//   FirestoreDatabase({required this.uid}) : assert(uid != null);
//   final String uid;
//   final _service = FirestoreService.instance;
//
//   @override
//   Future<void> setJob(Job job) => _service.setData(
//         path: ApiPath.job(uid, job.id),
//         data: job.toMap(),
//       );
//
//   @override
//   Future<void> deleteJob(Job job) => _service.deleteData(path: ApiPath.job(uid, job.id));
//
//   //Job一覧データ
//   @override
//   Stream<List<Job?>> jobsStream() => _service.collectionStream(
//         path: ApiPath.jobs(uid),
//         builder: (data, documentId) => Job.fromMap(data, documentId),
//       );
// }
