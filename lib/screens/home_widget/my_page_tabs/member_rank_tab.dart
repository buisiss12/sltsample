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
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Flexible(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset('assets/images/350x219membercard.png'),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Flexible(
                        child: Text('会員ランク: Regular'),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          //アイコンの数指定
                          children: buildDiamondIcons(3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          Flexible(
            child: ListView.builder(
              itemCount: Utility.shops.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(Utility.shops[index]),
                  children: <Widget>[
                    ListTile(title: Text(Utility.regularBenefits)),
                    ListTile(title: Text(Utility.rubyBenefits)),
                    ListTile(title: Text(Utility.sapphireBenefits)),
                    ListTile(title: Text(Utility.diamondBenefits)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
