import 'package:caretutors_assignment_task_note_app/data/data_sources/note_data_sources.dart';
import 'package:caretutors_assignment_task_note_app/data/repositories/note_ripository_impl.dart';
import 'package:caretutors_assignment_task_note_app/domain/repositories/note_repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/note.dart';

final noteRepositoryProvider = Provider<NoteRepositories>((ref){
  return NoteRipositoryImpl(NoteDataSources());
});

final getAllNotesProvider = StreamProvider.family<List<Note>,String>((ref, userId){
  return ref.read(noteRepositoryProvider).getAllNotes(userId);
});

final addNoteProvider = FutureProvider.family<void,Map<String,String>>((ref, data){
  final userId = data['userId']!;
  final title = data['title']!;
  final noteDescription = data['noteDescription']!;
  return ref.read(noteRepositoryProvider).addNotes(userId, title, noteDescription);
});

// final deleteNoteProvider = FutureProvider(_createFn)
