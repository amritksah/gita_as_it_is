import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  DateTime? dob;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    nameController.text = user.displayName ?? "";
    loadDOB();
  }

  Future<void> loadDOB() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists && doc.data()!['dob'] != null) {
      setState(() {
        dob = DateTime.parse(doc['dob']);
      });
    }
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser!;
    if (nameController.text.trim().isEmpty || dob == null) return;

    setState(() => loading = true);

    // 🔹 Update display name
    await user.updateDisplayName(nameController.text.trim());

    // 🔹 Save DOB to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'dob': dob!.toIso8601String(),
    }, SetOptions(merge: true));

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

    Navigator.pop(context);
  }

  Future<void> pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dob ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => dob = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Display Name",
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.cake),
              title: Text(
                dob == null
                    ? "Select Date of Birth"
                    : "DOB: ${dob!.day}/${dob!.month}/${dob!.year}",
              ),
              trailing: const Icon(Icons.edit),
              onTap: pickDOB,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: loading ? null : saveProfile,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
