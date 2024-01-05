import 'main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
