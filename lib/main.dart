// ignore_for_file: avoid_print

import 'package:sltsampleapp/screens/home_1/solotte_page.dart';
import 'screens/before_login/login_page.dart';
import 'provider/provider.dart';
import 'firebase_options/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'solotteサンプル',
      theme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const SolottePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
