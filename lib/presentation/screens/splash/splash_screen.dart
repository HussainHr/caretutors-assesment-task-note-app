// import 'package:caretutors_assignment_task_note_app/configs/app_configs/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SplashScreen extends HookConsumerWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//    
//     Future.delayed(const Duration(seconds: 6), () {
//       final isLoggedIn = FirebaseAuth.instance.currentUser != null;
//       if (isLoggedIn) {
//         context.go('/home');
//       } else {
//         context.go('/login');
//       }
//     });
//
//     return const Scaffold(
//       backgroundColor: AppColors.goldColor2,
//       body: Center(
//         child: Text(
//           'Welcome to Note App',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

import 'package:caretutors_assignment_task_note_app/configs/app_configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      if (mounted) {
        if (isLoggedIn) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.goldColor2,
      body: Center(
        child: Text(
          'Welcome to Note App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
