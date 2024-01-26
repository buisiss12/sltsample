import 'solotte_page.dart';
import 'package:flutter/material.dart';

class OriAgPage extends StatefulWidget {
  const OriAgPage({super.key});

  @override
  State<OriAgPage> createState() => _OriAgPageState();
}

class _OriAgPageState extends State<OriAgPage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_appbarTitle[_currentPageIndex]),
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
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          selectedIndex: _currentPageIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.emoji_events),
              label: '特典',
            ),
            NavigationDestination(
              icon: Icon(Icons.store),
              label: '店内人数',
            ),
            NavigationDestination(
              icon: Icon(Icons.qr_code_scanner),
              label: 'チェックイン',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu),
              label: 'メニュー',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long),
              label: '会計',
            ),
          ],
        ),
        body: SafeArea(child: pages[_currentPageIndex]),
      ),
    );
  }

  final List<String> _appbarTitle = [
    '特典',
    '店内人数',
    'チェックイン',
    'メニュー',
    '会計',
  ];

  List<Widget> pages = [
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
}
