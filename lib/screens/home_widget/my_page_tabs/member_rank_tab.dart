import 'package:flutter/material.dart';

class MemberRankTab extends StatelessWidget {
  const MemberRankTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset('assets/images/450x250membercard.png'),
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '会員ランク',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.diamond,
                      color: Colors.white,
                      size: 40,
                    ),
                    Icon(
                      Icons.diamond,
                      color: Colors.white,
                      size: 40,
                    ),
                    Icon(
                      Icons.diamond,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
