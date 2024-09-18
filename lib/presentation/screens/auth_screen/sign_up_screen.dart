import 'package:caretutors_assignment_task_note_app/configs/app_configs/connectivity_checker.dart';
import 'package:caretutors_assignment_task_note_app/presentation/common_widget/custom_auth_button.dart';
import 'package:caretutors_assignment_task_note_app/presentation/common_widget/custom_toast_message.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../configs/app_configs/app_colors.dart';
import '../../common_widget/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final isPasswordVisible = useState(false);
    final isLoading = useState(false);
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameFocusNode = FocusNode();
    final emailFocusNode = FocusNode();
    final passwordFocusNode = FocusNode();
    NetworkUtils networkUtils = NetworkUtils();

    useEffect(() {
      return () {
        usernameController.dispose();
        emailController.dispose();
        passwordController.dispose();
        nameFocusNode.dispose();
        emailFocusNode.dispose();
        passwordFocusNode.dispose();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SignUp',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFormField(
                topHeight: 15,
                keyboardType: TextInputType.text,
                controller: usernameController,
                textInputAction: TextInputAction.next,
                hintText: 'Enter your full name',
                labelText: 'Full Name',
                focusNode: nameFocusNode,
                nextFocusNode: emailFocusNode,
                onFieldSubmitted: () {
                  emailFocusNode.requestFocus();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                topHeight: 20,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                textInputAction: TextInputAction.next,
                hintText: 'Enter your email',
                labelText: 'Email',
                focusNode: emailFocusNode,
                nextFocusNode: passwordFocusNode,
                onFieldSubmitted: () {
                  passwordFocusNode.requestFocus();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email cannot be empty';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                topHeight: 20,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                hintText: 'Enter your password',
                labelText: 'Password',
                obscureText: !isPasswordVisible.value,
                focusNode: passwordFocusNode,
                onFieldSubmitted: () {},
                suffixIcon: GestureDetector(
                  onTap: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                  child: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.blackColor,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              isLoading.value
                  ? const CircularProgressIndicator()
                  : CustomAuthButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          final hasInternet =
                              await networkUtils.checkInternetConnectivity();
                          if (!hasInternet) {
                            showToast(
                                "no internet connection. Please try again");
                            return;
                          }
                          isLoading.value = true;
                          final credentials = {
                            'userName': usernameController.text,
                            'email': emailController.text,
                            'password': passwordController.text,
                          };
                          ref
                              .read(signUpProvider(credentials).future)
                              .then((user) {
                            if (user != null) {
                              isLoading.value = false;
                              showToast(
                                  "SignUp Successfully, Welcome ${user.displayName}");
                              context.go('/home');
                            }
                          }).catchError((error) {
                            isLoading.value = false;
                            showToast(error.toString());
                          });
                        } else {
                          throw Exception("PLease fill all the field");
                        }
                      },
                      color: AppColors.greenColor,
                      buttonName: "SignUp"),
              const SizedBox(height: 100),
              CustomAuthButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  color: AppColors.lightRedColor,
                  buttonName: 'Back to Login'),
            ],
          ),
        ),
      ),
    );
  }
}
