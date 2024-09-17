import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../domain/entities/note.dart';
import '../../providers/note_provider.dart';

class AddNoteScreen extends HookConsumerWidget {
  final Note? note;

  const AddNoteScreen({this.note, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: note?.title ??"");
    final contentController = useTextEditingController(text: note?.noteDescription??"");
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 8,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final data = {
                  'userId': user!.uid,
                  'title': titleController.text,
                  'noteDescription': contentController.text,
                };

                if (note == null) {
                  ref.read(addNoteProvider(data).future).then((_) {
                    context.go('/home');
                  });
                } else {
                  ref.read(noteRepositoryProvider).updateNote(
                    user.uid,
                    note!.id,
                    titleController.text,
                    contentController.text,
                  ).then((_) {
                    context.go('/home');
                  });
                }
              },
              child: Text(note == null ? 'Add Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
