import 'solotte_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OriAgPage extends HookWidget {
  const OriAgPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final pageController = usePageController();

    final List<Widget> pages = [
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
      const Center(child: Text('second Page')),
      const Center(child: Text('Third Page')),
      const Center(child: Text('force Page')),
      const Center(child: Text('fifth Page')),
    ];

    final List<String> labels = [
      '特典',
      '店内人数',
      'チェックイン',
      'メニュー',
      '会計',
    ];

    final List<IconData> icons = [
      Icons.emoji_events,
      Icons.store,
      Icons.qr_code_scanner,
      Icons.restaurant_menu,
      Icons.receipt_long,
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
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) {
          selectedIndex.value = index;
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
        destinations: List.generate(labels.length, (index) {
          return NavigationDestination(
            icon: Icon(icons[index]),
            label: labels[index],
          );
        }),
      ),
    );
  }
}
