import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatelessWidget {
  final String appbarTitle;
  final String url;
  final bool showAppBar;

  const WebviewPage({
    super.key,
    required this.appbarTitle,
    required this.url,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: Text(appbarTitle))
          : null, // 店内人数のページでのみ既にAppBarが実装されているため無効化
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
