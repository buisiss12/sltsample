import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticePage extends StatelessWidget {
  NoticePage({super.key});

  final controller = WebViewController()
    ..loadRequest(Uri.parse('https://oriental-lounge.com/information/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
