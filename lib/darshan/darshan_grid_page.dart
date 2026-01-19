import 'package:flutter/material.dart';
import 'darshan_model.dart';
import 'darshan_view_page.dart';

class DarshanGridPage extends StatelessWidget {
  const DarshanGridPage({super.key});

  List<DarshanImage> get images => [
        // 🟦 KRISHNA
        DarshanImage(
          title: 'Sakshi Gopal',
          imagePath: 'assets/darshan/krishna/sakshi_gopal.jpeg',
          category: 'Krishna',
        ),
        DarshanImage(
          title: 'Sri Sri Radha Parthsarthi',
          imagePath:
              'assets/darshan/krishna/sri_sri_radha_parthsarthi.jpeg',
          category: 'Krishna',
        ),

        // 🟦 GURUS
        DarshanImage(
          title: 'HH Bhakti Ashraya Maharaj',
          imagePath: 'assets/darshan/gurus/bhavm.jpeg',
          category: 'Gurus',
        ),
        DarshanImage(
          title: 'HH Gopal Krishna Goswami',
          imagePath: 'assets/darshan/gurus/gkgm.jpeg',
          category: 'Gurus',
        ),
        DarshanImage(
          title: 'HH Lokanath Swami',
          imagePath: 'assets/darshan/gurus/lnsm.jpeg',
          category: 'Gurus',
        ),
        DarshanImage(
          title: 'Srila Prabhupada',
          imagePath: 'assets/darshan/gurus/sg.jpeg',
          category: 'Gurus',
        ),
        DarshanImage(
          title: 'Srila Gour Govinda Swami',
          imagePath: 'assets/darshan/gurus/sgt.jpeg',
          category: 'Gurus',
        ),
        DarshanImage(
          title: 'Srila Jayapataka Swami',
          imagePath: 'assets/darshan/gurus/sjdbm.jpeg',
          category: 'Gurus',
        ),

        // 🟦 DHAMS
        DarshanImage(
          title: 'Jagannath Puri',
          imagePath: 'assets/darshan/dhams/jp.jpeg',
          category: 'Dham',
        ),
        DarshanImage(
          title: 'Sri Mayapur Dham',
          imagePath: 'assets/darshan/dhams/mayapur.jpeg',
          category: 'Dham',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Darshan – Sacred Images'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final img = images[index];

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DarshanViewPage(image: img),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      img.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      img.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
