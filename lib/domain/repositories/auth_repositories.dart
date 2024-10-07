import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepositories {
  Future<User?> signUp(String userName, String email, String password);
  Future<User?> login(String email, String password);
  Future<User?> signInWithGoogle();
  Future<User?> facebookLogin();
  Future<void> logOut();
  Stream<User?> authStateChange();
  Future<String?> uploadProfileImage(File imageFile, String userId);
  Future<void> updateProfile(String displayName, String email, String? photoURL);
  
}
