import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sltsampleapp/models/post_model.dart';
import 'package:sltsampleapp/screens/after_login/solotte_page.dart';
import '../../provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPostPage extends HookConsumerWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);

    final postTitle = useState('');

    final selectedTodohuken = useState<List<String>>([]);

    const List<String> todohuken = [
      '北海道',
      '青森県',
      '岩手県',
      '宮城県',
      '秋田県',
      '山形県',
      '福島県',
      '茨城県',
      '栃木県',
      '群馬県',
      '埼玉県',
      '千葉県',
      '東京都',
      '神奈川県',
      '新潟県',
      '富山県',
      '石川県',
      '福井県',
      '山梨県',
      '長野県',
      '岐阜県',
      '静岡県',
      '愛知県',
      '三重県',
      '滋賀県',
      '京都府',
      '大阪府',
      '兵庫県',
      '奈良県',
      '和歌山県',
      '鳥取県',
      '島根県',
      '岡山県',
      '広島県',
      '山口県',
      '徳島県',
      '香川県',
      '愛媛県',
      '高知県',
      '福岡県',
      '佐賀県',
      '長崎県',
      '熊本県',
      '大分県',
      '宮崎県',
      '鹿児島県',
      '沖縄県',
    ];

    void showPrefectureSelectionDialog() async {
      final List<String> selectedValues = List.from(selectedTodohuken.value);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('都道府県を選択'),
            content: SingleChildScrollView(
              child: ListBody(
                children: todohuken.map((String prefecture) {
                  return CheckboxListTile(
                    value: selectedValues.contains(prefecture),
                    title: Text(prefecture),
                    onChanged: (bool? value) {
                      if (value == true) {
                        if (!selectedValues.contains(prefecture)) {
                          selectedValues.add(prefecture);
                        }
                      } else {
                        selectedValues.remove(prefecture);
                      }
                      (context as Element).markNeedsBuild();
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("キャンセル"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  selectedTodohuken.value = selectedValues;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> addPost() async {
      final auth = ref.watch(firebaseAuthProvider);
      final user = auth.currentUser;
      if (user != null &&
          postTitle.value.isNotEmpty &&
          selectedTodohuken.value.isNotEmpty) {
        final post = PostModel(
          useruid: user.uid,
          todohuken: selectedTodohuken.value,
          posttitle: postTitle.value,
          timestamp: DateTime.now(),
        );

        await firestore.collection('posts').add(post.toJson());

        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const SolottePage(),
          ));
        }
      }
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          const Text('希望地域'),
          TextField(
            onTap: () => showPrefectureSelectionDialog(),
            controller:
                TextEditingController(text: selectedTodohuken.value.join(', ')),
            readOnly: true,
          ),
          const Text('募集内容'),
          TextField(
            onChanged: (value) {
              postTitle.value = value;
            },
          ),
          ElevatedButton(
            onPressed:
                postTitle.value.isNotEmpty && selectedTodohuken.value.isNotEmpty
                    ? addPost
                    : null,
            child: const Text('投稿する'),
          ),
        ],
      ),
    );
  }
}
