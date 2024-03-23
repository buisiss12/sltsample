import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // Flutter Webの場合、新規タブを開く
    if (kIsWeb) {
      return Scaffold(
        appBar: showAppBar ? AppBar(title: Text(appbarTitle)) : null,
        body: Center(
          child: TextButton(
            onPressed: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: const Text(
              'Flutter for Webの場合は新規タブを開きます。',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
      );
    } else {
      // iOSとAndroidの場合、WebViewを使用
      return Scaffold(
        appBar: showAppBar ? AppBar(title: Text(appbarTitle)) : null,
        body: WebViewWidget(
          controller: WebViewController()..loadRequest(Uri.parse(url)),
        ),
      );
    }
  }
}
