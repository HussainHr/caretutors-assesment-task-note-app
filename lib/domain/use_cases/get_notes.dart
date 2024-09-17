import '../entities/note.dart';
import '../repositories/note_repositories.dart';

class GetNotes{
  NoteRepositories repositories;

  GetNotes(this.repositories);

  Stream<List<Note>> call(userId){
    return repositories.getAllNotes(userId);
  }
}