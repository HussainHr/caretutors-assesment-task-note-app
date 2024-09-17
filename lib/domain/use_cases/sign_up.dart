import 'package:caretutors_assignment_task_note_app/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp {
  AuthRepositories repositories;

  SignUp(this.repositories);
  
  Future<User?> call(String userName, String email, String password)  {
    return repositories.signUp(userName, email, password);
  }
}
