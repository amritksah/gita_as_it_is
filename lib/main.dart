import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:audio_service/audio_service.dart';
import 'listen/kirtan_audio_handler.dart';
import 'listen/mini_player_bar.dart';

import 'firebase_options.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'verify_email_page.dart';
import 'gita_home_dashboard.dart';

/// 🌍 GLOBAL AUDIO HANDLER
late final KirtanAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  audioHandler = await AudioService.init(
    builder: () => KirtanAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.gita.kirtan',
      androidNotificationChannelName: 'Kirtan Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(const GitaApp());
}

class GitaApp extends StatelessWidget {
  const GitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhagavad Gita As It Is',

      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/verify': (_) => const VerifyEmailPage(),
      },

      home: const RootWithMiniPlayer(),
    );
  }
}

/// 🧠 ROOT WRAPPER (THIS FIXES EVERYTHING)
class RootWithMiniPlayer extends StatelessWidget {
  const RootWithMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔄 MAIN APP CONTENT
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final user = snapshot.data;

              if (user == null) {
                return const LoginPage();
              }

              if (!user.emailVerified &&
                  user.providerData.any(
                    (p) => p.providerId == 'password',
                  )) {
                return const VerifyEmailPage();
              }

              return const GitaHomeDashboard();
            },
          ),

          /// 🎶 MINI PLAYER (GLOBAL & PERSISTENT)
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayerBar(),
          ),
        ],
      ),
    );
  }
}
