import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  Job({required this.id, required this.name, required this.ratePerHour});

  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(QueryDocumentSnapshot data, String documentId) {
    final String name = data.get('name');
    final int ratePerHour = data.get('ratePerHour');
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
