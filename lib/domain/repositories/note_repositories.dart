import 'package:caretutors_assignment_task_note_app/domain/entities/note.dart';

abstract class NoteRepositories {
  Future<void> addNotes(String userId, String title, String noteDescription);
  Stream<List<Note>> getAllNotes(String userId);
  Future<void> deleteNotes(String userId, String noteId,String title, String noteDescription);
  Future<void> updateNote(
      String userId, String noteId, String title, String noteDescription);
}
