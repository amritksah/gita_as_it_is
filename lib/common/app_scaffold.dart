import 'package:flutter/material.dart';
import '../listen/mini_player_bar.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          // 🔹 MAIN PAGE CONTENT
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: body,
          ),

          // 🔹 PERSISTENT MINI PLAYER
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayerBar(),
          ),
        ],
      ),
    );
  }
}
