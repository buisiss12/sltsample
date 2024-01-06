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
          : _currentIndex == 4
              ? ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        title: const Text('プロフィール編集'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('ブロック済みのユーザー'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('各種設定'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('ログアウト'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('よくある質問'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('お問い合わせ'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('オリエンタルラウンジHP'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('ag(アグ)HP'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('リクルート'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('アプリを評価する'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('利用規約'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('プライバシーポリシー'),
                        onTap: () {},
                      ),
                      const Text(
                        'SOLOTTE!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ).toList(),
                )
              : Container(),
    );
  }
}
