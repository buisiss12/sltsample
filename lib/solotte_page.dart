// ignore_for_file: avoid_print

import 'oriag_page.dart';
import 'user_profile_page.dart';
import 'viewpost_page.dart';
import 'addpost_page.dart';
import 'settings_drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SolottePage extends HookWidget {
  const SolottePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final pageController = usePageController();

    final List<Widget> pages = [
      const ViewPostPage(),
      const Center(child: Text('2 Page')),
      const AddPostPage(),
      const Center(child: Text('お知らせ Page')),
      const UserProfilePage(),
    ];

    final List<String> labels = [
      'ホーム',
      'メッセージ',
      '投稿',
      'お知らせ',
      'プロフィール',
    ];

    final List<IconData> icons = [
      Icons.home,
      Icons.email,
      Icons.edit_note,
      Icons.notifications,
      Icons.person,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(labels[selectedIndex.value]),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/images/263x105oriag.png'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OriAgPage()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => selectedIndex.value = index,
        children: pages,
      ),
      drawer: const SettingsDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) {
          selectedIndex.value = index;
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
        destinations: List.generate(labels.length, (index) {
          return NavigationDestination(
            icon: Icon(icons[index]),
            label: labels[index],
          );
        }),
      ),
    );
  }
}
