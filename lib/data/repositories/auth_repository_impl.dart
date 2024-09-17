import 'package:caretutors_assignment_task_note_app/data/data_sources/auth_data_sources.dart';
import 'package:caretutors_assignment_task_note_app/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepositories {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(AuthDataSources authDataSources, {FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided.');
        default:
          throw Exception('Failed to login: ${e.message}');
      }
    }
  }

  @override
  Future<User?> signUp(String userName, String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(userName);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('The account already exists for that email.');
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        default:
          throw Exception("Failed to sign up: ${e.message}");
      }
    }
  }

  @override
  Stream<User?> authStateChange() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception("Failed to log out ${e.message}");
    }
  }
}
