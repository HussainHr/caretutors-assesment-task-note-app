import 'package:caretutors_assignment_task_note_app/domain/entities/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDataSources {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNote(
      String userId, String title, String noteDescription) async {
    await _firestore.collection('users').doc(userId).collection('notes').add({
      'title': title,
      'noteDescription': noteDescription,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Note>> getAllNotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Note(
                  id: doc.id,
                  title: data['title']??"",
                  noteDescription: data['noteDescription']??"");
            }).toList());
  }

  Future<void> deleteNote(String userId, String noteId,) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Future<void> updateNote(String userId, String noteId, String title,
      String noteDescription) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({
      'title': title,
      "noteDescription": noteDescription,
    });
  }
}
