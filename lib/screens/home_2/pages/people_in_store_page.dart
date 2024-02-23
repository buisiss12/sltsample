import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PeopleInStorePage extends HookWidget {
  const PeopleInStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://oriental-lounge.com/#shop'));

    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }
}
