import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sltsampleapp/screens/home_1/solotte_page.dart';
import 'package:sltsampleapp/screens/home_2/pages/people_in_store_page.dart';

class OriAgPage extends HookWidget {
  OriAgPage({super.key});

  final labelsList = [
    '特典',
    '店内人数',
    'チェックイン',
    'メニュー',
    '会計',
  ];

  final iconsList = [
    Icons.emoji_events,
    Icons.store,
    Icons.qr_code_scanner,
    Icons.restaurant_menu,
    Icons.receipt_long,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(labelsList[currentIndex.value]),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/images/263x105solotte.png'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SolottePage()),
              );
            },
          ),
        ],
      ),
      body: <Widget>[
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
      ][currentIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.value,
        onDestinationSelected: (index) => currentIndex.value = index,
        destinations: List.generate(
          labelsList.length,
          (index) {
            return NavigationDestination(
              icon: Icon(iconsList[index]),
              label: labelsList[index],
            );
          },
        ),
      ),
    );
  }
}
