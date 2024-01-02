import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 0;

  final _pageOptions = [
    const SolottePage(),
    const OriAgPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'solotteサンプル',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  _selectedPage = (_selectedPage + 1) % _pageOptions.length;
                });
              },
              child: Stack(
                alignment: Alignment.bottomCenter, // テキストを画像の下部中央に配置
                children: <Widget>[
                  Image.asset(_selectedPage == 0
                      ? 'assets/images/263x105olag.png'
                      : 'assets/images/263x105solotte.png'),
                  Text(
                    _selectedPage == 0 ? "タップで掲示板へ" : "タップで店舗メニューへ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: _pageOptions[_selectedPage],
      ),
    );
  }
}

class SolottePage extends StatefulWidget {
  const SolottePage({super.key});

  @override
  State<SolottePage> createState() => _SolottePageState();
}

class _SolottePageState extends State<SolottePage> {
  int _currentIndex = 0;

  void _incrementCounter(int index) {
    setState(() {
      _currentIndex = index;
    });
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
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _incrementCounter,
      ),
    );
  }
}

class OriAgPage extends StatefulWidget {
  const OriAgPage({super.key});

  @override
  State<OriAgPage> createState() => _OriAgPageState();
}

class _OriAgPageState extends State<OriAgPage> {
  int _currentIndex = 0;

  void _incrementCounter(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: '特典',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: '店内人数',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'メニュー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: '会計',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'お知らせ',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _incrementCounter,
      ),
    );
  }
}
