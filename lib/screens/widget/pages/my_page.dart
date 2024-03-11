import 'package:sltsampleapp/provider/provider.dart';
import 'package:sltsampleapp/screens/widget/pages/edit_profile_page.dart';
import 'package:sltsampleapp/screens/widget/pages/webview_page.dart';
import 'package:sltsampleapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
                            Tab(text: 'ランク'),
                            Tab(text: '特別会員'),
                            Tab(text: '称号'),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: const TabBarView(
                    physics: NeverScrollableScrollPhysics(),
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
        color: Colors.black,
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
            Image.asset('assets/images/300x188rank.png'),
            Column(
              children: <Widget>[
                const Text(
                  'ランク: Regular',
                  style: TextStyle(color: Colors.black),
                ),
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
              "ランク",
              "来店頻度、時間、アンケート回答数などにより評点が計算されます。\nランクが高くなると様々な特典を受け取ることができます。\n評点の計算方法などは随時アップデートされますので、急な点数の上下が発生することがありますがご了承ください。",
              () {},
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.help_outline,
                size: 20,
              ),
              Text(
                'ランクについて',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...Utility.shops
            .map(
              (shop) => ExpansionTile(
                title: Text(shop),
                children: [
                  ListTile(
                    title: const Text('Regularランク'),
                    subtitle: Text(Utility.regularRank),
                  ),
                  ListTile(
                    title: const Text('Rubyランク'),
                    subtitle: Text(Utility.rubyRank),
                  ),
                  ListTile(
                    title: const Text('sapphireランク'),
                    subtitle: Text(Utility.sapphireRank),
                  ),
                  ListTile(
                    title: const Text('diamondランク'),
                    subtitle: Text(Utility.diamondRank),
                  ),
                ],
              ),
            )
            .toList(),
      ],
    );
  }
}

class SpecialMemberTab extends HookWidget {
  const SpecialMemberTab({super.key});

  @override
  Widget build(BuildContext context) {
    final utility = Utility();

    final picIndex = useState(0);
    final currentTitle = utility.getMemberTitle(picIndex.value);
    final currentColor = utility.getMemberColor(picIndex.value);
    final currentBenefits = utility.getMemberBenefits(picIndex.value);

    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Text(
            currentTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: PageView.builder(
            itemCount: 3,
            controller: PageController(viewportFraction: 0.75),
            onPageChanged: (index) => picIndex.value = index,
            itemBuilder: (context, index) {
              return Image.asset('assets/images/440x275card${index + 1}.png');
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WebviewPage(
                  appbarTitle: 'メンバーズクラブ',
                  url: 'https://oriental-lounge.com/members/',
                ),
              ),
            );
          },
          child: Text("$currentTitleに入会する"),
        ),
        const SizedBox(height: 16),
        ...currentBenefits
            .map(
              (text) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: currentColor,
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: Text(text)),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}

class HonorTab extends StatelessWidget {
  const HonorTab({super.key});

  @override
  Widget build(BuildContext context) {
    //データベースとの通信（未実装のため数値を指定）
    const honorTitle = '初回来店';
    const currentValue = 1;
    const maxValue = 2;
    const progressValue = currentValue / maxValue;
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 16),
        const Text('オリエンタルラウンジ・agへのご来店や滞在で付与される称号です。'),
        const SizedBox(height: 16),
        ListTile(
          leading: Image.asset('assets/images/100x100coin.png'),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/150x40ribbon.png'),
                  const Text(
                    honorTitle,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 16), // titleとsubtitleの間のスキマ
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("$currentValue/$maxValue"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
