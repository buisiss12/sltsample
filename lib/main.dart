// ignore_for_file: avoid_print

import 'login_page.dart';
import 'solotte_page.dart';
import 'oriag_page.dart';
import 'package:flutter/material.dart';
import 'package:sltsampleapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //プッシュ通知
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final token = await messaging.getToken();
  print('🐯 FCM TOKEN: $token');

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
      home: const LoginPage(),
      /*Scaffold(
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
      ), */
    );
  }
}
