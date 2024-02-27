import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse("https://oriental-lounge.com/information/")),
      ),
    );
  }
}
