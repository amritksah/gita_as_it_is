import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'about_page.dart';
import 'gita/chapters_page.dart';
import 'mantras/mantras_home_page.dart';
import 'favorites/favorites_page.dart';
import 'darshan/darshan_grid_page.dart';
import 'listen/kirtan_playlist_page.dart';

import 'common/app_scaffold.dart'; // ✅ NEW

class GitaHomeDashboard extends StatelessWidget {
  const GitaHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    final displayChar = (user.displayName?.isNotEmpty ?? false)
        ? user.displayName![0].toUpperCase()
        : user.email![0].toUpperCase();

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Bhagavad Gita As It Is'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
              },
              child: SizedBox(
                width: 36,
                height: 36,
                child: ClipOval(
                  child: user.photoURL != null
                      ? Image.network(
                          '${user.photoURL}?sz=200',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _fallbackAvatar(displayChar);
                          },
                        )
                      : _fallbackAvatar(displayChar),
                ),
              ),
            ),
          ),
        ],
      ),

      // 🧱 DASHBOARD BODY (UNCHANGED)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _DashboardCard(
              icon: Icons.menu_book,
              title: 'Read Gita',
              subtitle: 'All 18 Chapters',
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChaptersPage(),
                  ),
                );
              },
            ),

            _DashboardCard(
              icon: Icons.headphones,
              title: 'Listen',
              subtitle: 'Kirtan & Bhajans',
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const KirtanPlaylistPage(),
                  ),
                );
              },
            ),

            _DashboardCard(
              icon: Icons.temple_hindu,
              title: 'Darshan',
              subtitle: 'Sacred Images',
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DarshanGridPage(),
                  ),
                );
              },
            ),

            _DashboardCard(
              icon: Icons.self_improvement,
              title: 'Mantras',
              subtitle: 'Chant & Meditate',
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MantrasHomePage(),
                  ),
                );
              },
            ),

            // ✅ QUIZ CARD (NOW CLICKABLE)
            _DashboardCard(
              icon: Icons.menu_book_outlined,
              title: 'Books',
              subtitle: 'Scriptures & Literature',
              onTap: (context) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('📚 Books section coming soon...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            _DashboardCard(
              icon: Icons.favorite,
              title: 'Favorites',
              subtitle: 'Saved Verses',
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritesPage(),
                  ),
                );
              },
            ),

            _DashboardCard(
              icon: Icons.person,
              title: 'My Profile',
              subtitle: 'Account Info',
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
              },
            ),

            _DashboardCard(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App Info & Contact',
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔁 FALLBACK AVATAR
Widget _fallbackAvatar(String displayChar) {
  return Container(
    color: Colors.deepPurple,
    alignment: Alignment.center,
    child: Text(
      displayChar,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final void Function(BuildContext context)? onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap != null ? () => onTap!(context) : null,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
