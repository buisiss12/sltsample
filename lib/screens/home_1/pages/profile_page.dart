// ignore_for_file: avoid_print
import 'package:flutter/services.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStateFuture = ref.watch(userStateFutureProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: userStateFuture.when(
          data: (userList) => ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              final age = Utility.birthdayToAgeConverter(user.birthday);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: user.profileImageUrl.isNotEmpty
                                ? NetworkImage(user.profileImageUrl)
                                : const AssetImage(
                                        'assets/images/300x300defaultprofile.png')
                                    as ImageProvider,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditUserProfilePage(user: user),
                                ),
                              );
                            },
                            child: const Text('プロフィールを編集'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ニックネーム: ${user.nickName}'),
                            Text('性別: ${user.gender}'),
                            Text('年齢: $age'),
                            Text('身長: ${user.height}'),
                            Text('職業: ${user.job}'),
                            Text('居住地: ${user.residence}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

class EditUserProfilePage extends ConsumerWidget {
  final UserModel user;

  const EditUserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = TextEditingController(text: user.nickName);
    final genderController = TextEditingController(text: user.gender);
    final heightController = TextEditingController(text: user.height);
    final jobController = TextEditingController(text: user.job);
    final residenceController = TextEditingController(text: user.residence);

    final imagePicker = ImagePicker();
    final selectedImage = ref.watch(selectedProfileImageProvider);

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('プロフィール編集')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                                      'assets/images/300x300defaultprofile.png'))
                              as ImageProvider,
                    ),
                  );
                },
              ),
              TextField(
                controller: nicknameController,
                decoration: const InputDecoration(hintText: 'ニックネーム'),
              ),
              IgnorePointer(
                child: TextField(
                  controller: genderController,
                  decoration: const InputDecoration(hintText: '性別'),
                  style: TextStyle(color: Colors.grey[700]),
                  readOnly: true,
                ),
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(hintText: '身長'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextField(
                controller: jobController,
                decoration: const InputDecoration(hintText: '職業'),
              ),
              TextField(
                  controller: residenceController,
                  decoration: const InputDecoration(hintText: '居住地'),
                  readOnly: true,
                  onTap: () => Utility.selectSinglePrefectureDialog(
                      context, residenceController)),
              ElevatedButton(
                onPressed: () async {
                  String? imageUrl;
                  if (selectedImage != null) {
                    String fileName = 'profileImage_${user.userUid}.jpg';
                    final fireStorage = ref.watch(firebaseStorageProvider);
                    final storageRef = fireStorage
                        .ref()
                        .child('profileImages')
                        .child(fileName);
                    await storageRef.putFile(selectedImage);
                    imageUrl = await storageRef.getDownloadURL();
                  } else {
                    imageUrl = user.profileImageUrl;
                  }

                  final updatedUser = user.copyWith(
                    nickName: nicknameController.text,
                    profileImageUrl: imageUrl,
                    height: heightController.text,
                    job: jobController.text,
                    residence: residenceController.text,
                  );
                  await ref.read(userStateAPIProvider).createUser(updatedUser);
                  ref.invalidate(userStateFutureProvider);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
