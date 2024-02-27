import 'package:sltsampleapp/screens/home_1/pages/addpost_page.dart';
import 'package:sltsampleapp/screens/home_1/pages/drawer_page.dart';
import 'package:sltsampleapp/screens/home_1/pages/posts_page.dart';
import 'package:sltsampleapp/screens/home_1/pages/profile_page.dart';
import 'package:sltsampleapp/screens/home_1/pages/recent_message_page.dart';
import 'package:sltsampleapp/screens/home_2/oriag_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SolottePage extends HookWidget {
  SolottePage({super.key});

  final labelsList = [
    '掲示板',
    'メッセージ',
    '投稿',
    'お知らせ',
    'プロフィール',
  ];

  final iconsList = [
    Icons.assignment,
    Icons.email,
    Icons.edit_note,
    Icons.notifications,
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
            icon: Image.asset('assets/images/263x105oriag.png'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OriAgPage()),
              );
            },
          ),
        ],
      ),
      drawer: const DrawerPage(),
      body: <Widget>[
        const PostsPage(),
        const RecentMessagePage(),
        const AddPostPage(),
        const Center(child: Text('お知らせ Page')),
        const UserProfilePage(),
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
