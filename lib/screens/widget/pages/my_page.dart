import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/widget/pages/edit_profile_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStateFuture = ref.watch(userStateFutureProvider);
    final utility = Utility();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userStateFuture.when(
          data: (users) {
            final user = users.isNotEmpty ? users.first : null;
            if (user != null) {
              final age = utility.birthdayToAgeConverter(user.birthday);
              return DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Card(
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
                                              return EditProfilePage(
                                                  user: user);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      ),
                      const SliverAppBar(
                        pinned: true, //trueの場合、スクロールしても上にBarが残る
                        floating: true,
                        expandedHeight: 10, //barの高さ
                        bottom: TabBar(
                          tabs: [
                            Tab(text: '会員ランク'),
                            Tab(text: '特別会員'),
                            Tab(text: '称号'),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: const TabBarView(
                    children: [
                      MemberRankTab(),
                      SpecialMemberTab(),
                      HonorTab(),
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

class MemberRankTab extends StatelessWidget {
  const MemberRankTab({super.key});

  List<Widget> buildDiamondIcons(int count) {
    return List.generate(
      count,
      (index) => const Icon(
        Icons.diamond,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset('assets/images/membercard.png'),
            Column(
              children: <Widget>[
                const Text('会員ランク: Regular'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  //アイコンの数指定
                  children: buildDiamondIcons(3),
                ),
              ],
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Utility.showDialogAPI(
              context,
              "会員ランク",
              "来店頻度、時間、アンケート回答数などにより評点が計算されます。\nランクが高くなると様々な特典を受け取ることができます。\n評点の計算方法などは随時アップデートされますので、急な点数の上下が発生することがありますがご了承ください。",
              () {},
            );
          },
          child: const Text(
            '会員ランクについて',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(height: 16),
        ...Utility.shops
            .map(
              (shop) => ExpansionTile(
                title: Text(shop),
                children: [
                  ListTile(
                    title: const Text('Regular会員'),
                    subtitle: Text(Utility.regularBenefits),
                  ),
                  ListTile(
                    title: const Text('Ruby会員'),
                    subtitle: Text(Utility.rubyBenefits),
                  ),
                  ListTile(
                    title: const Text('sapphire会員'),
                    subtitle: Text(Utility.sapphireBenefits),
                  ),
                  ListTile(
                    title: const Text('diamond会員'),
                    subtitle: Text(Utility.diamondBenefits),
                  ),
                ],
              ),
            )
            .toList(),
      ],
    );
  }
}

class SpecialMemberTab extends StatelessWidget {
  const SpecialMemberTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 16),
        const Center(child: Text("各会員")),
        SizedBox(
          height: 150,
          child: PageView(
            children: [
              Image.asset('assets/images/320x200card1.png'),
              Image.asset('assets/images/320x200card2.png'),
              Image.asset('assets/images/320x200card3.png'),
            ],
          ),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text("会員に入会する"),
        ),
      ],
    );
  }
}

class HonorTab extends StatelessWidget {
  const HonorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        Text('オリエンタルラウンジ・agへのご来店や滞在で付与される称号です。'),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('称号 テスト'),
          subtitle: Text('メーター'),
        ),
      ],
    );
  }
}
