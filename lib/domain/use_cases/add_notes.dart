import 'package:caretutors_assignment_task_note_app/domain/repositories/note_repositories.dart';

class AddNotes{
  NoteRepositories repositories;
  
  AddNotes(this.repositories);
  
  Future<void> call(String userId,String title, String noteDescription){
    return repositories.addNotes(userId, title, noteDescription);
  }
}