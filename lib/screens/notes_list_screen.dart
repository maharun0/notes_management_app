import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/notes_service.dart';
import 'note_edit_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final NotesService _service = NotesService();
  late final Stream<List<Note>> _notes = _service.watchNotes();

  void _openEditor([Note? note]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => NoteEditScreen(note: note)),
    );
  }

  Future<void> _delete(Note note) async {
    try {
      await _service.deleteNote(note.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not delete note: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: StreamBuilder<List<Note>>(
        stream: _notes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data ?? const <Note>[];
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet. Tap + to add one.'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  note.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _openEditor(note),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                  onPressed: () => _delete(note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openEditor,
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
