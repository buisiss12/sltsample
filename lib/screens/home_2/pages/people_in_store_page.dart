import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PeopleInStorePage extends StatelessWidget {
  const PeopleInStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://oriental-lounge.com/#shop'));

    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
