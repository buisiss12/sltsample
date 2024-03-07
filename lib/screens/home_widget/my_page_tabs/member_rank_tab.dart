import 'package:flutter/material.dart';
import 'package:sltsampleapp/utils/utility.dart';

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
