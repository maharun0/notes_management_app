import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

/// The only place Firestore is touched. Each method maps to one CRUD operation.
class NotesService {
  final CollectionReference<Map<String, dynamic>> _notes =
      FirebaseFirestore.instance.collection('notes');

  /// Read: live stream of notes, newest first.
  Stream<List<Note>> watchNotes() {
    return _notes
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Note.fromDoc).toList());
  }

  /// Create.
  Future<void> addNote(String title, String description) {
    return _notes.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update.
  Future<void> updateNote(String id, String title, String description) {
    return _notes.doc(id).update({
      'title': title,
      'description': description,
    });
  }

  /// Delete.
  Future<void> deleteNote(String id) => _notes.doc(id).delete();
}
