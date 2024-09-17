import 'package:caretutors_assignment_task_note_app/presentation/providers/auth_provider.dart';
import 'package:caretutors_assignment_task_note_app/presentation/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final credential = {
                  'email': emailController.text.toString(),
                  'password': passwordController.text.toString(),
                };

                ref.read(loginProvider(credential).future).then((user) {
                  if (user != null) {
                    ref.refresh(getAllNotesProvider(user.uid));
                    context.go("/home");
                  }
                }).catchError((error) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                });
              },
              child: Text('Login'),
            ),

            ElevatedButton(onPressed: (){context.go('/signup');}, child: Text('Sign Up'),)
           
          ],
        ),
      ),
    );
  }
}
