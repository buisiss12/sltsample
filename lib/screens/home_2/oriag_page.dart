import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sltsampleapp/screens/home_1/solotte_page.dart';
import 'package:sltsampleapp/screens/home_2/pages/people_in_store_page.dart';

class OriAgPage extends HookWidget {
  const OriAgPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final pageController = usePageController();

    final labels = [
      '特典',
      '店内人数',
      'チェックイン',
      'メニュー',
      '会計',
    ];

    final icons = [
      Icons.emoji_events,
      Icons.store,
      Icons.qr_code_scanner,
      Icons.restaurant_menu,
      Icons.receipt_long,
    ];

    final pages = [
      const DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            TabBar(
              labelPadding: EdgeInsets.symmetric(vertical: 15.0),
              tabs: [
                Text('会員ランク'),
                Text('特別会員'),
                Text('称号'),
              ],
            ),
          ],
        ),
      ),
      const PeopleInStorePage(),
      const Center(child: Text('チェックイン Page')),
      const Center(child: Text('メニュー Page')),
      const Center(child: Text('会計 Page')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(labels[selectedIndex.value]),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/images/263x105solotte.png'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SolottePage()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => selectedIndex.value = index,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) {
          selectedIndex.value = index;
          pageController.jumpToPage(index);
        },
        destinations: List.generate(
          labels.length,
          (index) {
            return NavigationDestination(
              icon: Icon(icons[index]),
              label: labels[index],
            );
          },
        ),
      ),
    );
  }
}
