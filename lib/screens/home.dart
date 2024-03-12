import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Project imports:
import 'package:sltsampleapp/screens/widget/pages/webview_page.dart';
import 'package:sltsampleapp/screens/widget/pages/settings_page.dart';
import 'package:sltsampleapp/screens/widget/pages/posts_page.dart';
import 'package:sltsampleapp/screens/widget/pages/my_page.dart';
import 'package:sltsampleapp/screens/widget/pages/recent_message_page.dart';

class Home extends HookWidget {
  Home({super.key});

  final labelsList = [
    '掲示板',
    'メッセージ',
    '店内人数',
    'メニュー',
    'マイページ',
  ];

  final iconsList = [
    Icons.assignment,
    Icons.email,
    Icons.store,
    Icons.restaurant_menu,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(labelsList[currentIndex.value]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebviewPage(
                    appbarTitle: 'お知らせ',
                    url: 'https://oriental-lounge.com/information/',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: <Widget>[
        const PostsPage(),
        const RecentMessagePage(),
        const WebviewPage(
            appbarTitle: '',
            url: 'https://oriental-lounge.com/#shop',
            showAppBar: false),
        const Center(child: Text('メニュー')),
        const MyPage(),
      ][currentIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.value,
        onDestinationSelected: (index) => currentIndex.value = index,
        destinations: List.generate(
          labelsList.length,
          (index) {
            return NavigationDestination(
              icon: Icon(iconsList[index]),
              label: labelsList[index],
            );
          },
        ),
      ),
    );
  }
}
