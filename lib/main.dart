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
      title: 'solotteサンプル',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('SLTサンプル'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                _selectedPage = (_selectedPage + 1) % _pageOptions.length;
              });
            },
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
