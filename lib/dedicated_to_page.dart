import 'package:flutter/material.dart';

class DedicatedToPage extends StatelessWidget {
  const DedicatedToPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dedicated To'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🌸 PRABHUPADA PHOTO (SIZE CONTROLLED)
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/prabhupada.jpeg',
                width: 160,
                height: 210,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    children: const [
                      Icon(Icons.broken_image,
                          color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text('Prabhupada image not found'),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 🌼 NAME
            const Text(
              'His Divine Grace\n'
              'A.C. Bhaktivedanta Swami Śrīla Prabhupāda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // 🌺 DIVIDER
            Container(
              width: 80,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 22),

            // 📜 DEDICATION TEXT
            const Text(
              'This humble offering is lovingly placed at the lotus feet of '
              'His Divine Grace A.C. Bhaktivedanta Swami Śrīla Prabhupāda — '
              'the empowered ācārya who carried the timeless wisdom of the '
              'Bhagavad-gītā across oceans and continents, awakening countless '
              'souls to their eternal relationship with Śrī Kṛṣṇa.\n\n'
              'Whatever beauty, truth, or value this effort may hold '
              'exists solely by his causeless mercy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.65,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            // 🪔 FOOTER
            const Text(
              'All glories to Śrīla Prabhupāda 🙏',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
