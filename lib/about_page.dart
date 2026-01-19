import 'package:flutter/material.dart';
import 'dedicated_to_page.dart';
import 'contact_us_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Bhagavad Gita As It Is',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'This app is created to help devotees read, understand, and apply the teachings of the Bhagavad Gita in daily life.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // ✅ DEDICATED TO
          Card(
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.deepPurple),
              title: const Text('Dedicated To'),
              subtitle: const Text('Our spiritual inspiration'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DedicatedToPage(), // ❌ NO const
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ✅ CONTACT US
          Card(
            child: ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.deepPurple),
              title: const Text('Contact Us'),
              subtitle: const Text('Get in touch'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContactUsPage(), // ❌ NO const
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
