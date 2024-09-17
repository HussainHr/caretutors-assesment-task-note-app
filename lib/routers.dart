import 'package:caretutors_assignment_task_note_app/presentation/screens/auth_screen/login_screen.dart';
import 'package:caretutors_assignment_task_note_app/presentation/screens/auth_screen/sign_up_screen.dart';
import 'package:caretutors_assignment_task_note_app/presentation/screens/home/home_screen.dart';
import 'package:caretutors_assignment_task_note_app/presentation/screens/note_screen/note_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'domain/entities/note.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
        path: '/add-note',
        builder: (context, state) {
          final note = state.extra as Note?;
          return AddNoteScreen(
            note: note,
          );
        }),
  ],
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (!isLoggedIn && state.matchedLocation != '/signup') {
      return '/signup';
    }
    return null;
  },
);
