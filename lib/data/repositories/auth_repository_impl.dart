import 'dart:io';
import 'package:caretutors_assignment_task_note_app/data/data_sources/auth_data_sources.dart';
import 'package:caretutors_assignment_task_note_app/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepositoryImpl implements AuthRepositories {
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  final AuthDataSources authDataSources;

  AuthRepositoryImpl(this.authDataSources,
      {FirebaseAuth? firebaseAuth, FirebaseStorage? firebaseStorage})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    return await authDataSources.uploadProfileImage(imageFile, userId);
    try {
      final storageRef = _firebaseStorage.ref().child('profile_images/$userId/profile.jpg');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }
  
  @override
  Future<void> updateProfile(String displayName,String email, String? photoURL) async {
    return await authDataSources.updateProfile(displayName, email, photoURL);
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.verifyBeforeUpdateEmail(email);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }

        // After updating, reload the user to apply changes
        await user.reload();
        user = _firebaseAuth.currentUser;  // This will ensure the updated user data is retrieved
      } else {
        throw Exception("No user is logged in.");
      }
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }


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
      await userCredential.user?.reload();
      return _firebaseAuth.currentUser;
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

  @override
  Future<User?> facebookLogin() {
   return authDataSources.signInWithGoogle();
  }

  @override
  Future<User?> signInWithGoogle() {
   return authDataSources.facebookLogin();
  }
  
}
