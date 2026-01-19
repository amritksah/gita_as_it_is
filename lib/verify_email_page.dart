import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;
  bool isSending = false;

  @override
  void initState() {
    super.initState();

    // 🔁 Check email verification every 3 seconds
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      checkEmailVerified();
    });
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;

    await user?.reload(); // 🔄 Refresh Firebase user

    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
        timer?.cancel(); // 🛑 Stop checking

        if (!mounted) return;

        // 🚀 Navigate to HomePage
        Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      setState(() => isSending = true);

      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email sent 📩")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send email")),
      );
    } finally {
      setState(() => isSending = false);
    }
  }

  Future<void> logout() async {
    timer?.cancel();
    await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7B1FA2),
              Color(0xFF512DA8),
              Color(0xFF303F9F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.mark_email_unread_rounded,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Verify your email",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      user?.email ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "We are waiting for you to verify your email.\nThis page will update automatically.",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                        icon: const Icon(Icons.verified, color: Colors.white),
                        label: const Text("I've verified my email"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;

                            await user?.reload(); // 🔄 reload from server
                            final refreshedUser = FirebaseAuth.instance.currentUser;

                            if (refreshedUser != null && refreshedUser.emailVerified) {
                            if (!context.mounted) return;

                            Navigator.pushReplacementNamed(context, '/home');
                            } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                content: Text("Email not verified yet. Please check Gmail."),
                                ),
                            );
                            }
                        },
                        ),


                    const SizedBox(height: 16),

                    TextButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
