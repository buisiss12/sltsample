// ignore_for_file: avoid_print

import '../../provider/provider.dart';
import '../../models/model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final currentUser = auth.currentUser;

    final userStateFuture = ref.watch(userStateFutureProvider);

    if (currentUser == null) {
      return const Center(child: Text('ログインしてください'));
    }
    return Scaffold(
      body: userStateFuture.when(
        data: (userList) => ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final user = userList[index];
            return ListTile(
              title: Text(user.realname),
              subtitle: Text(user.gender),
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class EditProfilePage extends HookConsumerWidget {
  final Map<String, dynamic> initialData;

  const EditProfilePage({super.key, required this.initialData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final firestore = ref.watch(firebaseFirestoreProvider);
    final storage = ref.watch(firebaseStorageProvider);
    final currentUser = auth.currentUser;

    final nicknameController =
        TextEditingController(text: initialData['ニックネーム']);
    final genderController = TextEditingController(text: initialData['性別']);
    final liveLocationController =
        TextEditingController(text: initialData['居住地']);
    final workLocationController =
        TextEditingController(text: initialData['勤務地']);

    Future<void> uploadProfileImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        String fileName = 'profile_image_${currentUser?.uid}';
        try {
          TaskSnapshot snapshot =
              await storage.ref('profile_images').child(fileName).putFile(file);
          String imageUrl = await snapshot.ref.getDownloadURL();
          await firestore
              .collection('users')
              .doc(currentUser?.uid)
              .update({'profileImageUrl': imageUrl});
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child:
                      Models.loadProfileImage(initialData['profileImageUrl']),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: uploadProfileImage,
                  child: const Text('プロフィール写真を変更'),
                ),
              ),
            ],
          ),
          TextField(
              controller: nicknameController,
              decoration: const InputDecoration(labelText: 'ニックネーム')),
          TextField(
              enabled: false,
              controller: genderController,
              decoration: const InputDecoration(labelText: '性別')),
          TextField(
              controller: liveLocationController,
              decoration: const InputDecoration(labelText: '居住地')),
          TextField(
              controller: workLocationController,
              decoration: const InputDecoration(labelText: '勤務地')),
          ElevatedButton(
            onPressed: () {
              Map<String, dynamic> updatedUserData = {};
              if (nicknameController.text.isNotEmpty) {
                updatedUserData['ニックネーム'] = nicknameController.text;
              }
              if (genderController.text.isNotEmpty) {
                updatedUserData['性別'] = genderController.text;
              }
              if (liveLocationController.text.isNotEmpty) {
                updatedUserData['居住地'] = liveLocationController.text;
              }
              if (workLocationController.text.isNotEmpty) {
                updatedUserData['勤務地'] = workLocationController.text;
              }
              firestore
                  .collection('users')
                  .doc(currentUser?.uid)
                  .update(updatedUserData);
              Navigator.pop(context);
            },
            child: const Text('更新'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }
}
