import 'dart:io';
import 'package:caretutors_assignment_task_note_app/data/repositories/auth_repository_impl.dart';
import 'package:caretutors_assignment_task_note_app/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/data_sources/auth_data_sources.dart';

final authRepositoryProvider = Provider<AuthRepositories>((ref) {
  return AuthRepositoryImpl(AuthDataSources());
});

final authStateChangeProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryProvider).authStateChange();
});

final loginProvider =
    FutureProvider.family<User?, Map<String, String>>((ref, credentials) {
  return ref
      .read(authRepositoryProvider)
      .login(credentials['email']!, credentials['password']!);
});

final signUpProvider =
    FutureProvider.family<User?, Map<String, String>>((ref, credentials) {
  return ref.read(authRepositoryProvider).signUp(credentials['userName']!,
      credentials['email']!, credentials['password']!);
});

//Sign in with google provider
final googleSignInProvider = FutureProvider<User?>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.signInWithGoogle();
});

//Facebook login provider 
final facebookLoginProvider = FutureProvider<User?>((ref) async{
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.facebookLogin();
});

final logOutProvider = FutureProvider<void>((ref) {
  return ref.read(authRepositoryProvider).logOut();
});

// New Provider for Uploading Profile Image
final uploadProfileImageProvider =
    FutureProvider.family<String?, Map<String, dynamic>>((ref, data) {
  File imageFile = data['imageFile'] as File;
  String userId = data['userId'] as String;
  return ref.read(authRepositoryProvider).uploadProfileImage(imageFile, userId);
});
