import 'package:firebase_auth/firebase_auth.dart';
import 'package:sltsampleapp/login_page.dart';

import 'oriag_page.dart';
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
            icon: Icon(Icons.manage_accounts),
            label: '設定',
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
    '設定',
  ];

  List<Widget> pages = [
    const Center(child: Text('first Page')),
    const Center(child: Text('second Page')),
    const Center(child: Text('third Page')),
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
    Center(
      child: Builder(
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Fifth Page'),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('サインアウト'),
              ),
            ],
          );
        },
      ),
    ),
  ];
}
