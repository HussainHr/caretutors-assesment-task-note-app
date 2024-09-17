class Note {
  final String id;
  final String title;
  final String noteDescription;

  Note({
    required this.id,
    required this.title,
    required this.noteDescription,
  });

  factory Note.fromDocument(Map<String, dynamic> doc, String docId) {
    return Note(
      id: docId,
      title: doc['title'] ?? '',
      noteDescription: doc['noteDescription'] ?? '',
    );
  }

  // Convert the Note object to a Map to save it to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'noteDescription': noteDescription,
    };
  }
}
