import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedPage = 0;

  final _pageOptions = [
    const SolottePage(),
    const AgPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'solotteサンプル',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width * 0.3,
          leading: InkWell(
            onTap: () {
              setState(() {
                _selectedPage = (_selectedPage + 1) % _pageOptions.length;
              });
            },
            child: Stack(
              alignment: Alignment.bottomCenter, // テキストを画像の下部中央に配置
              children: <Widget>[
                _selectedPage == 0
                    ? Image.asset('assets/images/263x105olag.png')
                    : Image.asset('assets/images/263x105solotte.png'),
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
  int _counter = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Solotte: Tab 1')),
    Center(child: Text('Solotte: Tab 2')),
    Center(child: Text('Solotte: Tab 3')),
    Center(child: Text('Solotte: Tab 4')),
    Center(child: Text('Solotte: Tab 5')),
  ];

  void _incrementCounter(int index) {
    setState(() {
      _counter = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_counter),
      ),
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
        currentIndex: _counter,
        selectedItemColor: Colors.amber[800],
        onTap: _incrementCounter,
      ),
    );
  }
}

class AgPage extends StatefulWidget {
  const AgPage({super.key});

  @override
  State<AgPage> createState() => _AgPageState();
}

class _AgPageState extends State<AgPage> {
  int _counter = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('ag: Tab 1')),
    Center(child: Text('ag: Tab 2')),
    Center(child: Text('ag: Tab 3')),
    Center(child: Text('ag: Tab 4')),
    Center(child: Text('ag: Tab 5')),
  ];

  void _incrementCounter(int index) {
    setState(() {
      _counter = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_counter),
      ),
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
        currentIndex: _counter,
        selectedItemColor: Colors.amber[800],
        onTap: _incrementCounter,
      ),
    );
  }
}
