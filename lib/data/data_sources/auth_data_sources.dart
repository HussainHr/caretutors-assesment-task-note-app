import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDataSources {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  //upload user profile in firebase storage
  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      final storageRef =
          _firebaseStorage.ref().child("profile_images/$userId/profile.jpg");
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  // Update profile (name and photo URL)
  Future<void> updateProfile(
      String displayName, String email, String? photoURL) async {
    try {
      User? user = _firebaseAuth.currentUser;
      await user?.updateDisplayName(displayName);
      await user?.verifyBeforeUpdateEmail(email);
      if (photoURL != null) {
        await user?.updatePhotoURL(photoURL);
      }
      await user?.reload(); // Reload user to reflect changes
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  //LoginWith Facebook
  Future<User?> facebookLogin() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential oAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(oAuthCredential);
        return userCredential.user;
      } else {
        throw Exception('Facebook sing in failed');
      }
    } catch (e) {
      throw Exception('Failed to sign in with Facebook: $e');
    }
  }

  //SignInWithGoogleAccount
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google sign in canceled");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(authCredential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  //SignUp with email and password
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

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _facebookAuth.logOut();
  }

  Stream<User?> authStateChange() {
    return _firebaseAuth.authStateChanges();
  }
}
