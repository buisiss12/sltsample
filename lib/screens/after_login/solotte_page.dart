// ignore_for_file: avoid_print

import 'package:sltsampleapp/screens/after_login/message_users_page.dart';
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

    final labels = [
      '掲示板',
      'メッセージ',
      '投稿',
      'お知らせ',
      'プロフィール',
    ];
    final icons = [
      Icons.assignment,
      Icons.email,
      Icons.edit_note,
      Icons.notifications,
      Icons.person,
    ];

    final pages = [
      const ViewPostPage(),
      const MessageUsersPage(),
      const AddPostPage(),
      const Center(child: Text('お知らせ Page')),
      const UserProfilePage(),
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
          pageController.jumpToPage(index);
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
