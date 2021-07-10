import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  Entry({
    required this.id,
    required this.jobId,
    required this.start,
    required this.end,
    this.comment,
  });

  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String? comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(QueryDocumentSnapshot value, String id) {
    final int startMilliseconds = value.get('start');
    final int endMilliseconds = value.get('end');
    return Entry(
      id: id,
      jobId: value.get('jobId'),
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value.get('comment'),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
