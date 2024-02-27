import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PeopleInStorePage extends StatelessWidget {
  PeopleInStorePage({super.key});

  final controller = WebViewController()
    ..loadRequest(Uri.parse('https://oriental-lounge.com/#shop'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
