import 'package:flutter/material.dart';

class SpecialMemberTab extends StatelessWidget {
  const SpecialMemberTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(child: Text("各会員")),
          ElevatedButton(
            onPressed: null,
            child: Text("会員に入会する"),
          ),
        ],
      ),
    );
  }
}
