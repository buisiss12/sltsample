import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  String _appBarTitle = 'ホーム';

  final _pageOptions = [
    const SolottePage(),
    const OriAgPage(),
  ];

  final _appBarTitles = [
    'ホーム',
    '特典',
  ];

  void updateAppBarTitle(String title) {
    setState(() {
      _appBarTitle = title;
    });
  }

  void _changePage() {
    int newPage = (_selectedPage + 1) % _pageOptions.length;
    setState(() {
      _selectedPage = newPage;
      _appBarTitle = _appBarTitles[newPage];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'solotteサンプル',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
          actions: <Widget>[
            InkWell(
              onTap: _changePage,
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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    final appBarTitles = ['ホーム', 'メッセージ', '投稿', 'お知らせ', 'プロフィール'];
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
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
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
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _controller.runJavaScript(
                "document.getElementById('shop').scrollIntoView();");
          },
        ),
      );
  }

  void _checkPeople() {
    _controller.loadRequest(Uri.parse('https://oriental-lounge.com/'));
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    final appBarTitles = ['特典', '店内人数', 'メニュー', '会計', 'お知らせ'];
    (context as Element)
        .findAncestorStateOfType<MyAppState>()
        ?.updateAppBarTitle(appBarTitles[index]);
    if (index == 1) {
      _checkPeople();
    }
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
          onTap: _onItemTapped,
        ),
        body: _currentIndex == 1
            ? WebViewWidget(controller: _controller)
            : Container());
  }
}
