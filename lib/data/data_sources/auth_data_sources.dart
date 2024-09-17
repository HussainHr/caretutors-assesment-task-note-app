import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSources {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUp(String userName, String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(userName);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
  
  Future<void> logOut()async{
    await _firebaseAuth.signOut();
  }
  
  Stream<User?> authStateChange() {
    return _firebaseAuth.authStateChanges();
  }
}
