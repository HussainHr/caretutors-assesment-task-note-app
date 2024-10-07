import 'package:caretutors_assignment_task_note_app/configs/app_configs/app_colors.dart';
import 'package:caretutors_assignment_task_note_app/presentation/common_widget/custom_list_title.dart';
import 'package:caretutors_assignment_task_note_app/presentation/common_widget/custom_toast_message.dart';
import 'package:caretutors_assignment_task_note_app/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/note_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final notes = ref.watch(getAllNotesProvider(user?.uid ?? ''));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        leading: IconButton(
            onPressed: () {
              context.go('/profile');
            },
            icon: Icon(
              Icons.person,
              size: 26,
              color: Colors.white,
            )),
        centerTitle: true,
        title: const Text(
          'My Notes',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await ref.read(logOutProvider.future);
              ref.invalidate(getAllNotesProvider);
              ref.invalidate(authRepositoryProvider);
              FirebaseAuth.instance.authStateChanges().listen((User? user) {
                if (user == null) {
                  context.go('/login');
                } else {
                  throw Exception("Sorry");
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Welcome back, ${user!.displayName.toString()}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: notes.when(
              data: (notesList) {
                return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    final note = notesList[index];
                    return CustomListTile(
                        title: note.title,
                        subtitle: note.noteDescription,
                        onEdit: () {
                          context.push('/add-note', extra: note);
                        },
                        onDelete: () {
                          ref.read(noteRepositoryProvider).deleteNotes(
                                user.uid,
                                note.id,
                              );
                        });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bgColor,
        onPressed: () => context.go('/add-note'),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
