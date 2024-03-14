import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/models/user_model.dart';

class TestEditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;

  const TestEditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends ConsumerState<TestEditProfilePage> {
  final imagePicker = ImagePicker();
  late TextEditingController _nicknameController;
  String? _profileImageUrl =
      Image.asset('assets/images/300x300defaultprofile.png') as String?;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.user.nickName);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    // 画像を選択
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Firebase Storageにアップロード
      final file = File(pickedFile.path);
      final ref = ref
          .read(firebaseStorageProvider)
          .ref()
          .child('profile_images')
          .child(widget.user.userUid); // ユーザーUIDでファイル名を指定
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();

      // アップロードした画像のURLで_profileImageUrlを更新
      setState(() {
        _profileImageUrl = imageUrl;
      });

      // Firebase Firestoreにユーザー情報を更新
      await ref
          .read(firebaseFirestoreProvider)
          .collection('users')
          .doc(widget.user.userUid)
          .update({'profileImageUrl': imageUrl});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            InkWell(
              onTap: _pickAndUploadImage, // 画像選択とアップロードの関数を呼び出し
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : const AssetImage(
                                'assets/images/300x300defaultprofile.png')
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
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: 'ニックネーム'),
            ),
            ElevatedButton(
              onPressed: () async {
                // ニックネームの更新処理をここに追加
                final newUser = widget.user.copyWith(
                  nickName: _nicknameController.text,
                  profileImageUrl:
                      _profileImageUrl ?? widget.user.profileImageUrl,
                );
                await ref.read(userStateAPIProvider).createUser(newUser);
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
