import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:sltsampleapp/models/user_model.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/utils/utility.dart';

final selectedProfileImageProvider = StateProvider<File?>((ref) => null);

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends ConsumerState<EditProfilePage> {
  final utility = Utility();
  final imagePicker = ImagePicker();
  final nicknameController = TextEditingController();
  final genderController = TextEditingController();
  final heightController = TextEditingController();
  final jobController = TextEditingController();
  final residenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nicknameController.text = widget.user.nickName;
    genderController.text = widget.user.gender;
    heightController.text = widget.user.height;
    jobController.text = widget.user.job;
    residenceController.text = widget.user.residence;
  }

  @override
  void dispose() {
    nicknameController.dispose();
    genderController.dispose();
    heightController.dispose();
    jobController.dispose();
    residenceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(selectedProfileImageProvider.notifier).state =
          File(pickedFile.path);
    }
  }

  Future<void> _saveProfile() async {
    String? imageUrl;
    final selectedImage = ref.read(selectedProfileImageProvider);

    if (selectedImage != null) {
      final uploadTask = ref
          .read(firebaseStorageProvider)
          .ref('profileImage_${widget.user.userUid}.jpg')
          .putFile(selectedImage);
      final snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    final updatedUser = widget.user.copyWith(
      profileImageUrl: imageUrl ?? widget.user.profileImageUrl,
      nickName: nicknameController.text,
      height: heightController.text,
      job: jobController.text,
      residence: residenceController.text,
    );

    await ref.read(userStateAPIProvider).setUser(updatedUser);
    ref.invalidate(userStateFutureProvider); //Future型のためキャッシュをクリアして再セット

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage)
                                : (widget.user.profileImageUrl.isNotEmpty
                                        ? NetworkImage(widget.user.profileImageUrl)
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
                  onPressed: _saveProfile,
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
