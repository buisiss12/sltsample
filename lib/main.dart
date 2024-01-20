// ignore_for_file: avoid_print

import 'login_page.dart';
import 'solotte_page.dart';
import 'package:flutter/material.dart';
import 'package:sltsampleapp/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'solotteサンプル',
      theme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;
            print("ユーザーがログインしました: ${user.uid}, ${user.email}");
            return const SolottePage();
          }
          print("ユーザーはログアウト状態です");
          return const LoginPage();
        },
      ),
    );
  }
}
