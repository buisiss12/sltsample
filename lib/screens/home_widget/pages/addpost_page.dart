import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/home_widget/home_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// View側に処理を書いて、状態を管理したいなら、ConsumerStatefulWidgetを使う方が良い。
// buildメソッドの中に処理を書くと、再ビルドのたびに処理が走ってしまうため、
// アプリのパフォーマンスが低下する可能性がある。

class AddPostPage extends ConsumerStatefulWidget {
  const AddPostPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {

  // setStateを使って値を変更するための変数
  var postTitle = "";

  // ValueNotifierは値が変更されたときに、変更を検知してく通知する
  final selectedPrefecture = ValueNotifier<List<String>>([]);

  // Utilityクラスのインスタンスを生成
  final utility = Utility();

  // buildメソッドの中に処理を書くと、再ビルドのたびに処理が走ってしまうため、
  // ConsumerStateクラスの中に処理を書いて、パフォーマンスの低下を防ぐ
  Future<void> addPost() async {
      final auth = ref.watch(firebaseAuthProvider);
      final currentUser = auth.currentUser;
      final firestore = ref.watch(firebaseFirestoreProvider);
      if (currentUser != null &&
          postTitle.isNotEmpty &&
          selectedPrefecture.value.isNotEmpty) {
        final userDoc =
            await firestore.collection('users').doc(currentUser.uid).get();
        final userNickname = userDoc.data()?['nickName'];
        if (userNickname == null || userNickname.isEmpty) {
          // Statefulの場合は、contextがなくてもmountedだけで、mountedを使うことができる
          if (mounted) {
            utility.showSnackBarAPI(context, 'ニックネームを入力してください');
          }
          return;
        }
        final postModel = PostModel(
          postId: '',
          postedUserUid: currentUser.uid,
          prefecture: selectedPrefecture.value,
          postTitle: postTitle,
          timestamp: DateTime.now(),
        );

        final documentRef =
            await firestore.collection('posts').add(postModel.toJson());
        final postId = documentRef.id;

        await firestore
            .collection('posts')
            .doc(postId)
            .update({'postId': postId});

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
      }
      }
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('投稿')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                const Text('(注意事項)'),
                const Text('*アイコンがご自身が写った写真に設定していない場合、投稿を削除いたします。'),
                const Text(
                    '*宣伝、ネットワークビジネス、パーティー業者と見受けられるものは禁止となっております。見つけ次第、削除退会処置を取ります。'),
                const SizedBox(height: 16),
                const Text('希望地域'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '希望地域を選択',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                      text: selectedPrefecture.value.join(', ')),
                  readOnly: true,
                  onTap: () => utility.selectMultiPrefectureDialog(
                    context,
                    selectedPrefecture,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('募集内容'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '本文',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  minLines: 4,
                  onChanged: (value) {
                    setState(() {
                    postTitle = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: postTitle.isNotEmpty &&
                          selectedPrefecture.value.isNotEmpty
                      ? addPost
                      : null,
                  child: const Text('投稿する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// buildメソッドの中に、処理が書かれていると、再ビルドのたびに処理が走ってしまうため、
// この書き方はやめておいた方が良い。

// class AddPostPage extends HookConsumerWidget {
//   const AddPostPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final postTitle = useState('');

//     final selectedPrefecture = useState<List<String>>([]);

//     final utility = Utility();

//     Future<void> addPost() async {
//       final auth = ref.watch(firebaseAuthProvider);
//       final currentUser = auth.currentUser;
//       final firestore = ref.watch(firebaseFirestoreProvider);
//       if (currentUser != null &&
//           postTitle.value.isNotEmpty &&
//           selectedPrefecture.value.isNotEmpty) {
//         final userDoc =
//             await firestore.collection('users').doc(currentUser.uid).get();
//         final userNickname = userDoc.data()?['nickName'];
//         if (userNickname == null || userNickname.isEmpty) {
//           if (context.mounted) {
//             utility.showSnackBarAPI(context, 'ニックネームを入力してください');
//           }
//           return;
//         }
//         final postModel = PostModel(
//           postId: '',
//           postedUserUid: currentUser.uid,
//           prefecture: selectedPrefecture.value,
//           postTitle: postTitle.value,
//           timestamp: DateTime.now(),
//         );

//         final documentRef =
//             await firestore.collection('posts').add(postModel.toJson());
//         final postId = documentRef.id;

//         await firestore
//             .collection('posts')
//             .doc(postId)
//             .update({'postId': postId});

//         if (context.mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => HomePage()),
//             (Route<dynamic> route) => false,
//           );
//         });
//       }
//       }
//     }

//     return GestureDetector(
//       onTap: () => primaryFocus?.unfocus(),
//       child: Scaffold(
//         appBar: AppBar(title: const Text('投稿')),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 const SizedBox(height: 16),
//                 const Text('(注意事項)'),
//                 const Text('*アイコンがご自身が写った写真に設定していない場合、投稿を削除いたします。'),
//                 const Text(
//                     '*宣伝、ネットワークビジネス、パーティー業者と見受けられるものは禁止となっております。見つけ次第、削除退会処置を取ります。'),
//                 const SizedBox(height: 16),
//                 const Text('希望地域'),
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: '希望地域を選択',
//                     border: OutlineInputBorder(),
//                   ),
//                   controller: TextEditingController(
//                       text: selectedPrefecture.value.join(', ')),
//                   readOnly: true,
//                   onTap: () => Utility().selectMultiPrefectureDialog(
//                     context,
//                     selectedPrefecture,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('募集内容'),
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: '本文',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: null,
//                   minLines: 4,
//                   onChanged: (value) {
//                     postTitle.value = value;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: postTitle.value.isNotEmpty &&
//                           selectedPrefecture.value.isNotEmpty
//                       ? addPost
//                       : null,
//                   child: const Text('投稿する'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
