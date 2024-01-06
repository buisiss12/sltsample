import 'main.dart';
import 'package:flutter/material.dart';

class SolottePage extends StatefulWidget {
  const SolottePage({super.key});

  @override
  State<SolottePage> createState() => _SolottePageState();
}

class _SolottePageState extends State<SolottePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    final appBarTitles = ['ホーム', 'メッセージ', '投稿', 'お知らせ', '設定'];
    (context as Element)
        .findAncestorStateOfType<MyAppState>()
        ?.updateAppBarTitle(appBarTitles[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'メッセージ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: '投稿',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'お知らせ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: '設定',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
      body: _currentIndex == 3
          ? const DefaultTabController(
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
            )
          : Container(),
    );
  }
}
