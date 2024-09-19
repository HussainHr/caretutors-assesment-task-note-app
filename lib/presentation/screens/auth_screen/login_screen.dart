import 'package:caretutors_assignment_task_note_app/presentation/common_widget/custom_auth_button.dart';
import 'package:caretutors_assignment_task_note_app/presentation/providers/auth_provider.dart';
import 'package:caretutors_assignment_task_note_app/presentation/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/app_configs/app_colors.dart';
import '../../../configs/app_configs/connectivity_checker.dart';
import '../../common_widget/custom_text_field.dart';
import '../../common_widget/custom_toast_message.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    final isPasswordVisible = useState(false);
    final isLoading = useState(false);
    final nameFocusNode = FocusNode();
    final emailFocusNode = FocusNode();
    final passwordFocusNode = FocusNode();
    NetworkUtils networkUtils = NetworkUtils();

    useEffect(() {
      return () {
        emailController.dispose();
        passwordController.dispose();
        nameFocusNode.dispose();
        emailFocusNode.dispose();
        passwordFocusNode.dispose();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.bgColor,
                    child: Icon(
                      Icons.person,
                      size: 95,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: AppColors.bgColor),
                ),
                CustomTextFormField(
                  topHeight: 20,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  maxLInes: 1,
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
                  maxLInes: 1,
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
                                  "No internet connection. Please try again");
                              return;
                            }
                            isLoading.value = true;
                            final credential = {
                              'email': emailController.text.toString(),
                              'password': passwordController.text.toString(),
                            };
                            ref
                                .read(loginProvider(credential).future)
                                .then((user) {
                              if (user != null) {
                                ref.refresh(getAllNotesProvider(user.uid));
                                isLoading.value = false;
                                showToast(
                                    "Login Successfully, Welcome ${user.displayName}");
                                context.go("/home");
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
                        buttonName: "Login"),
                TextButton(
                    onPressed: () {
                      context.go('/signup');
                    },
                    child: const Text('Don\'t have an Account- SignUp')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
