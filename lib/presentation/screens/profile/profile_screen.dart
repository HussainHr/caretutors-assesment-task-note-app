import 'dart:io';
import 'package:caretutors_assignment_task_note_app/presentation/common_widget/custom_toast_message.dart';
import 'package:caretutors_assignment_task_note_app/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final displayNameController =
        TextEditingController(text: user?.displayName ?? '');
    final displayEmailController =
        TextEditingController(text: user?.email);
    final selectedImage = useState<File?>(null);
    final isLoading = useState(false);

    Future<void> _pickImage() async {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        selectedImage.value = File(pickedImage.path);
      }
    }

    Future<void> _updateProfile() async {
      if (isLoading.value) return;
      isLoading.value = true;
      try {
        String? profileImageUrl;
        if (selectedImage.value != null) {
          profileImageUrl = await ref.read(uploadProfileImageProvider({
            'imageFile': selectedImage.value,
            'userId': user!.uid,
          }).future);
        }
        // Update profile (name,email and photo URL)
        await ref.read(authRepositoryProvider).updateProfile(
              displayNameController.text,
              displayEmailController.text,
              profileImageUrl,
            );
        context.go('/home');
        showToast('Profile updated successfully!');
        
      } catch (e) {
        print("Hussian debuging : $e");
        showToast(e.toString());
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Update Profile'),
        leading: IconButton(
            onPressed: () {
              context.go('/home');
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: selectedImage.value != null
                  ? FileImage(selectedImage.value!)
                  : (user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/default_avatar.png')),
              child: selectedImage.value == null && user?.photoURL == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Change Image'),
            ),
            TextFormField(
              controller: displayNameController,
              decoration: const InputDecoration(labelText: 'Display Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              controller: displayEmailController,
              decoration: const InputDecoration(labelText: 'Display Email'),
            ),
            const SizedBox(height: 20),
            isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Update Profile'),
                  ),
          ],
        ),
      ),
    );
  }
}
