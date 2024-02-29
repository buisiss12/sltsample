import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/home_widget/my_page_tabs/member_rank_tab.dart';
import 'package:sltsampleapp/screens/home_widget/my_page_tabs/special_member_tab.dart';
import 'package:sltsampleapp/screens/home_widget/pages/edit_profile_page.dart';
import 'package:sltsampleapp/screens/home_widget/my_page_tabs/honor_tab.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStateFuture = ref.watch(userStateFutureProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userStateFuture.when(
          data: (users) {
            final user = users.isNotEmpty ? users.first : null;
            if (user != null) {
              final age = Utility.birthdayToAgeConverter(user.birthday);
              return SingleChildScrollView(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: user
                                            .profileImageUrl.isNotEmpty
                                        ? NetworkImage(user.profileImageUrl)
                                        : const AssetImage(
                                                'assets/images/300x300defaultprofile.png')
                                            as ImageProvider,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return EditProfilePage(user: user);
                                          },
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
                                    Row(
                                      children: [
                                        const Icon(Icons.person),
                                        const SizedBox(width: 8),
                                        Text('ニックネーム: ${user.nickName}'),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Icon(Icons.transgender),
                                        const SizedBox(width: 8),
                                        Text('性別: ${user.gender}'),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Icon(Icons.cake),
                                        const SizedBox(width: 8),
                                        Text('年齢: $age'),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Icon(Icons.height),
                                        const SizedBox(width: 8),
                                        Text('身長: ${user.height}'),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Icon(Icons.work),
                                        const SizedBox(width: 8),
                                        Text('職業: ${user.job}'),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Icon(Icons.home),
                                        const SizedBox(width: 8),
                                        Text('居住地: ${user.residence}'),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const TabBar(
                        tabs: [
                          Tab(text: '会員ランク'),
                          Tab(text: '特別会員'),
                          Tab(text: '称号'),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight: 300), // 高さ指定しないと無限にレンダリングされるためエラーになる
                        child: const TabBarView(
                          children: [
                            MemberRankTab(),
                            SpecialMemberTab(),
                            HonorTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('ユーザーデータがありません。'));
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(child: Text('エラーが発生しました: $e')),
        ),
      ),
    );
  }
}
