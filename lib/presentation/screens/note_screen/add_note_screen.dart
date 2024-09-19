import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/app_configs/app_colors.dart';
import '../../../configs/app_configs/connectivity_checker.dart';
import '../../../domain/entities/note.dart';
import '../../common_widget/custom_auth_button.dart';
import '../../common_widget/custom_text_field.dart';
import '../../common_widget/custom_toast_message.dart';
import '../../providers/note_provider.dart';

class AddNoteScreen extends HookConsumerWidget {
  final Note? note;

  const AddNoteScreen({this.note, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final isLoading = useState(false);
    final titleController = useTextEditingController(text: note?.title ?? "");
    final noteDescriptionController =
        useTextEditingController(text: note?.noteDescription ?? "");
    final user = FirebaseAuth.instance.currentUser;
    final titleFocusNode = FocusNode();
    final noteDescriptionFocusNode = FocusNode();
    NetworkUtils networkUtils = NetworkUtils();

    useEffect(() {
      return () {
        noteDescriptionFocusNode.dispose();
        titleFocusNode.dispose();
        titleController.dispose();
        noteDescriptionController.dispose();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
        title: Text(
          note == null ? 'Add Note' : 'Edit Note',
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              context.go('/home');
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  topHeight: 15,
                  keyboardType: TextInputType.text,
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  hintText: 'Write your title here',
                  labelText: 'Title',
                  focusNode: titleFocusNode,
                  nextFocusNode: noteDescriptionFocusNode,
                  onFieldSubmitted: () {
                    noteDescriptionFocusNode.requestFocus();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  topHeight: 20,
                  maxLInes: 5,
                  keyboardType: TextInputType.text,
                  controller: noteDescriptionController,
                  textInputAction: TextInputAction.next,
                  hintText: 'Write your description here',
                  labelText: 'Description',
                  focusNode: noteDescriptionFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
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
                            final data = {
                              'userId': user!.uid,
                              'title': titleController.text,
                              'noteDescription': noteDescriptionController.text,
                            };

                            try {
                              if (note == null) {
                                await ref
                                    .read(addNoteProvider(data).future)
                                    .then((_) {
                                  isLoading.value = false;
                                  showToast("Note added Successfully!");
                                  context.go('/home');
                                });
                              } else {
                                await ref
                                    .read(noteRepositoryProvider)
                                    .updateNote(
                                      user.uid,
                                      note!.id,
                                      titleController.text,
                                      noteDescriptionController.text,
                                    )
                                    .then((_) {
                                  showToast("Note update Successfully!");
                                  context.go('/home');
                                });
                              }
                            } catch (e) {
                              showToast(e.toString());
                            } finally {
                              isLoading.value = false;
                            }
                          }
                        },
                        color: AppColors.greenColor,
                        buttonName: note == null ? 'Add Note' : 'Update Note'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
