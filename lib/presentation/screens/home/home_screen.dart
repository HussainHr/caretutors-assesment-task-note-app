import 'package:caretutors_assignment_task_note_app/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/note_provider.dart';
class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final notes = ref.watch(getAllNotesProvider(user!.uid));

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ref.read(logOutProvider.future).then((_) {
                context.go('/');
              });
            },
          ),
        ],
      ),
      body: notes.when(
        data: (notesList) {
          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              final note = notesList[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.noteDescription),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Edit note functionality
                        context.push('/add-note', extra: note);
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.delete),
                    //   onPressed: () {
                    //     ref.read(noteRepositoryProvider).deleteNote(
                    //       user.uid,
                    //       note.id,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-note'),
        child: Icon(Icons.add),
      ),
    );
  }
}
