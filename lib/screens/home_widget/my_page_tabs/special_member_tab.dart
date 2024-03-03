import 'package:flutter/material.dart';

class SpecialMemberTab extends StatelessWidget {
  SpecialMemberTab({super.key});

  final List<String> imageList = [
    'assets/images/320x200card1.png',
    'assets/images/320x200card2.png',
    'assets/images/320x200card3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("各会員"),
          Flexible(
            child: PageView.builder(
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return Image.asset(imageList[index]);
              },
            ),
          ),
          const ElevatedButton(
            onPressed: null,
            child: Text("会員に入会する"),
          ),
        ],
      ),
    );
  }
}
