import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleAuthService {
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // ✅ WEB-SAFE Google Sign In
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      final User? user = userCredential.user;
      if (user == null) return null;

      // 🔥 Save user profile to Firestore (only once)
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final doc = await userRef.get();

      if (!doc.exists) {
        await userRef.set({
          'name': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
          'dob': null, // user can add later
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print("Google sign-in error: $e");
      rethrow;
    }
  }
}
