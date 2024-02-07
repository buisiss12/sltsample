// ignore_for_file: avoid_print
import 'package:sltsampleapp/models/model.dart';
import 'package:sltsampleapp/models/user_state.dart';
import '../../provider/provider.dart';
import 'package:flutter/material.dart';
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
            final age = Logics.birthdayToAge(user.birthday);
            return Card(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditUserProfilePage(user: user),
                        ),
                      );
                    },
                    child: const Text('プロフィールを編集'),
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: user.profileImageUrl.isEmpty
                        ? Image.asset('assets/images/profiledefault.png')
                        : null,
                  ),
                  Text('本名: ${user.realname}'),
                  Text('性別: ${user.gender}'),
                  Text('年齢: $age'),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class EditUserProfilePage extends ConsumerWidget {
  final UserState user;

  const EditUserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realnameController = TextEditingController(text: user.realname);

    final imagePicker = ImagePicker();
    final selectedImage = ref.watch(selectedProfileImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final selectedImage = ref.watch(selectedProfileImageProvider);
                return InkWell(
                  onTap: () async {
                    final pickedFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (pickedFile != null) {
                      ref.read(selectedProfileImageProvider.notifier).state =
                          File(pickedFile.path);
                    }
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage)
                        : (user.profileImageUrl.isNotEmpty
                                ? NetworkImage(user.profileImageUrl)
                                : const AssetImage(
                                    'assets/images/profiledefault.png'))
                            as ImageProvider,
                  ),
                );
              },
            ),
            TextField(
              controller: realnameController,
              decoration: const InputDecoration(labelText: '本名'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedImage != null) {
                  String fileName = 'profileImage_${user.useruid}.jpg';
                  final fireStorage = ref.watch(firebaseStorageProvider);
                  final storageRef =
                      fireStorage.ref().child('profileImages').child(fileName);
                  await storageRef.putFile(selectedImage);
                  final imageUrl = await storageRef.getDownloadURL();

                  final updatedUser = user.copyWith(
                    realname: realnameController.text,
                    profileImageUrl: imageUrl,
                  );
                  await ref.read(userStateAPIProvider).createUser(updatedUser);
                  ref.invalidate(userStateFutureProvider);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
