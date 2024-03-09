import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sltsampleapp/models/user_model.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/utils/utility.dart';

class EditProfilePage extends ConsumerWidget {
  final UserModel user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = TextEditingController(text: user.nickName);
    final genderController = TextEditingController(text: user.gender);
    final heightController = TextEditingController(text: user.height);
    final jobController = TextEditingController(text: user.job);
    final residenceController = TextEditingController(text: user.residence);

    final imagePicker = ImagePicker();
    final selectedImage = ref.watch(selectedProfileImageProvider);
    final utility = Utility();

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('プロフィール編集')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final selectedImage =
                        ref.watch(selectedProfileImageProvider);
                    return InkWell(
                      onTap: () async {
                        final pickedFile = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedFile != null) {
                          ref
                              .read(selectedProfileImageProvider.notifier)
                              .state = File(pickedFile.path);
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage)
                                : (user.profileImageUrl.isNotEmpty
                                        ? NetworkImage(user.profileImageUrl)
                                        : const AssetImage(
                                            'assets/images/300x300defaultprofile.png'))
                                    as ImageProvider,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'タップして変更',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'ニックネーム',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                IgnorePointer(
                  child: TextField(
                    controller: genderController,
                    decoration: const InputDecoration(
                      labelText: '性別',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.grey[700]),
                    readOnly: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: '身長',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: jobController,
                  decoration: const InputDecoration(
                    labelText: '職業',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: residenceController,
                  decoration: const InputDecoration(
                    labelText: '居住地',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => Utility.selectSinglePrefectureDialog(
                    context,
                    residenceController,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (nicknameController.text.trim().isEmpty) {
                      if (context.mounted) {
                        utility.showSnackBarAPI(context, 'ニックネームを入力してください');
                      }
                      return;
                    }
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
                    await ref
                        .read(userStateAPIProvider)
                        .createUser(updatedUser);
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
      ),
    );
  }
}
