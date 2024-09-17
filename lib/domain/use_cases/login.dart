import 'package:caretutors_assignment_task_note_app/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login{
  final AuthRepositories repositories;
  
  Login(this.repositories);
  
  Future<User?> call(String email, String password) {
    return repositories.login(email, password);
  }
}