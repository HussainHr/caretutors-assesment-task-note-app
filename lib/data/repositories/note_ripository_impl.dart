import 'package:caretutors_assignment_task_note_app/domain/entities/note.dart';
import 'package:caretutors_assignment_task_note_app/domain/repositories/note_repositories.dart';

import '../data_sources/note_data_sources.dart';

class NoteRipositoryImpl implements NoteRepositories{
  final NoteDataSources _dataSources;
  NoteRipositoryImpl(this._dataSources);
  
  @override
  Future<void> addNotes(String userId, String title, String noteDescription)async {
    return await _dataSources.addNote(userId, title, noteDescription);
    
  }

  @override
  Future<void> deleteNotes(String userId, String noteId,String title, String noteDescription ) async{
    return await _dataSources.deleteNote(userId, noteId, title, noteDescription);
  }
 
  @override
  Stream<List<Note>> getAllNotes(String userId) {
    return _dataSources.getAllNotes(userId);
  }

  @override
  Future<void> updateNote(String userId, String noteId, String title, String noteDescription)async {
    return await _dataSources.updateNote(userId, noteId, title, noteDescription);
  }
  
}