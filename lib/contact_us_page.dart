import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:bhav.amritkrishnadas@gmail.com');
    await launchUrl(uri);
  }

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:+916200869541');
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF3E5F5),
              Color(0xFFEDE7F6),
              Color(0xFFE8EAF6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // 🌸 TITLE
                const Text(
                  'We would love to hear from you',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Your feedback, suggestions, and reflections help us improve this '
                  'humble service offered in devotion to Śrī Kṛṣṇa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, height: 1.6),
                ),

                const SizedBox(height: 30),

                // 📧 EMAIL
                InkWell(
                  onTap: _launchEmail,
                  child: Column(
                    children: const [
                      Icon(Icons.email,
                          size: 36, color: Colors.deepPurple),
                      SizedBox(height: 6),
                      Text(
                        'bhav.amritkrishnadas@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📞 PHONE
                InkWell(
                  onTap: _launchPhone,
                  child: Column(
                    children: const [
                      Icon(Icons.phone,
                          size: 36, color: Colors.deepPurple),
                      SizedBox(height: 6),
                      Text(
                        '+91 6200869541',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // 🕉️ GITA QUOTE
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '“Whatever you do, whatever you eat, whatever you offer or give away, '
                        'and whatever austerities you perform—do that as an offering unto Me.”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '— Bhagavad Gītā 9.27',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🪔 FOOTER
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Your servant,\nAmrit Krishna Das',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Hare Kṛṣṇa 🙏'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
