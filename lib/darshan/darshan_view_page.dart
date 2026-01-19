import 'package:flutter/material.dart';
import 'darshan_model.dart';

class DarshanViewPage extends StatelessWidget {
  final DarshanImage image;

  const DarshanViewPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(image.title),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(image.imagePath),
        ),
      ),
    );
  }
}
