import 'package:caretutors_assignment_task_note_app/domain/repositories/auth_repositories.dart';

class LogOut{
  AuthRepositories repositories;
  
  LogOut(this.repositories);
  
  Future<void> call(){
    return repositories.logOut();
  }
}