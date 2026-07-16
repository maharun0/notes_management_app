import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;

  /// Null between a local create and the server resolving `serverTimestamp()`.
  final DateTime? createdAt;

  factory Note.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Note(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
