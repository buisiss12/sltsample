// ignore_for_file: avoid_print

import 'oriag_page.dart';
import 'settings_drawer_page.dart';
import 'package:flutter/material.dart';

class SolottePage extends StatefulWidget {
  const SolottePage({super.key});

  @override
  State<SolottePage> createState() => _SolottePageState();
}

class _SolottePageState extends State<SolottePage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appbarTitle[_currentPageIndex]),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/images/263x105olag.png'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OriAgPage()),
              );
            },
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const SettingsDrawer(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.email),
            label: 'メッセージ',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note),
            label: '投稿',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'お知らせ',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
      ),
      body: SafeArea(child: pages[_currentPageIndex]),
    );
  }

  final List<String> _appbarTitle = [
    'ホーム',
    'メッセージ',
    '投稿',
    'お知らせ',
    'プロフィール',
  ];

  List<Widget> pages = [
    const Center(child: Text('1 Page')),
    const Center(child: Text('2 Page')),
    const Center(child: Text('3 Page')),
    const DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          TabBar(
            labelPadding: EdgeInsets.symmetric(vertical: 15.0),
            tabs: [
              Text('すべて'),
              Text('開催中'),
              Text('終了'),
            ],
          ),
        ],
      ),
    ),
    const Center(child: Text('5 Page')),
  ];
}
