// import 'package:caretutors_assignment_task_note_app/domain/use_cases/login.dart';
// import 'package:caretutors_assignment_task_note_app/presentation/screens/auth_screen/login_screen.dart';
// import 'package:caretutors_assignment_task_note_app/presentation/screens/auth_screen/sign_up_screen.dart';
// import 'package:caretutors_assignment_task_note_app/presentation/screens/home/home_screen.dart';
// import 'package:caretutors_assignment_task_note_app/presentation/screens/note_screen/note_screen.dart';
// import 'package:caretutors_assignment_task_note_app/presentation/screens/splash/splash_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_router/go_router.dart';
//
// import 'domain/entities/note.dart';
//
// final router = GoRouter(
//   initialLocation: '/',
//   routes: [
//     GoRoute(
//       path: "/",
//       builder: (context, state) => const SplashScreen(),
//     ),
//    
//     GoRoute(
//         path: "/login",
//         builder: (context, state) => const LoginScreen(),
//         redirect: (context, state){
//           final isLoggedIn = FirebaseAuth.instance.currentUser != null;
//           if(isLoggedIn){
//             return '/home';
//           }
//           return null;
//         }
//     ),
//     GoRoute(
//       path: '/home',
//       builder: (context, state) => HomeScreen(),
//       redirect: (context, state) {
//         final isLoggedIn = FirebaseAuth.instance.currentUser != null;
//         if (!isLoggedIn) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/signup',
//       builder: (context, state) => SignUpScreen(),
//       redirect: (context, state) {
//         final isLoggedIn = FirebaseAuth.instance.currentUser != null;
//         if (isLoggedIn) {
//           return '/home';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//         path: '/add-note',
//         builder: (context, state) {
//           final note = state.extra as Note?;
//           return AddNoteScreen(
//             note: note,
//           );
//         }),
//   ],
//   redirect: (context, state) {
//     final isLoggedIn = FirebaseAuth.instance.currentUser != null;
//     if (!isLoggedIn) {
//       return '/login';
//     }
//     return null;
//   },
// );

import 'package:caretutors_assignment_task_note_app/presentation/screens/auth_screen/login_screen.dart';
import 'package:caretutors_assignment_task_note_app/presentation/screens/auth_screen/sign_up_screen.dart';
import 'package:caretutors_assignment_task_note_app/presentation/screens/home/home_screen.dart';
import 'package:caretutors_assignment_task_note_app/presentation/screens/note_screen/note_screen.dart';
import 'package:caretutors_assignment_task_note_app/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'domain/entities/note.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      // redirect: (context, state) async {
      //   await Future.delayed(const Duration(seconds: 2));
      //   final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      //   return isLoggedIn ? '/home' : '/login';
      // },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) =>  SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add-note',
      builder: (context, state) {
        final note = state.extra as Note?;
        return AddNoteScreen(note: note);
      },
    ),
  ],
 
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isSplashRoutes = state.matchedLocation == '/';

    final isGoingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
    if (isLoggedIn && isGoingToAuth) {
      return '/home';
    }

    if (!isLoggedIn && state.matchedLocation != '/login' && state.matchedLocation != '/signup' && !isSplashRoutes) {
      return '/login';
    }
    
    return null;
  },
);
