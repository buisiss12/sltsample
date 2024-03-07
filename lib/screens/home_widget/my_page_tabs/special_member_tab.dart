import 'package:flutter/material.dart';

class SpecialMemberTab extends StatelessWidget {
  const SpecialMemberTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 16),
        const Center(child: Text("各会員")),
        SizedBox(
          height: 150,
          child: PageView(
            children: [
              Image.asset('assets/images/320x200card1.png'),
              Image.asset('assets/images/320x200card2.png'),
              Image.asset('assets/images/320x200card3.png'),
            ],
          ),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text("会員に入会する"),
        ),
      ],
    );
  }
}
