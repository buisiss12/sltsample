import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'solotteサンプル',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Icon(
        Icons.home,
        size: 150,
      ),
    ),
    Center(
      child: Icon(
        Icons.search,
        size: 150,
      ),
    ),
    Center(
      child: Icon(
        Icons.favorite,
        size: 150,
      ),
    ),
    Center(
      child: Icon(
        Icons.message,
        size: 150,
      ),
    ),
    Center(
      child: Icon(
        Icons.settings,
        size: 150,
      ),
    ),
  ];

  void _incrementCounter(int index) {
    setState(() {
      _counter = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SLTサンプル'),
      ),
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
