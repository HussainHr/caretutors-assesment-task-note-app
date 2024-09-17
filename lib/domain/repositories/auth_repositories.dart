import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepositories {
  Future<User?> signUp(String userName, String email, String password);
  Future<User?> login(String email, String password);
  Future<void> logOut();
  Stream<User?> authStateChange();
}
