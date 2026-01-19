import 'package:flutter/material.dart';

class MantraDetailPage extends StatefulWidget {
  final Map<String, String> mantra;

  const MantraDetailPage({super.key, required this.mantra});

  @override
  State<MantraDetailPage> createState() => _MantraDetailPageState();
}

class _MantraDetailPageState extends State<MantraDetailPage> {
  bool isHindi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      appBar: AppBar(
        title: Text(widget.mantra['title']!),
        centerTitle: true,
        backgroundColor: const Color(0xFF512DA8),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => setState(() => isHindi = !isHindi),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    widget.mantra['sanskrit']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.7,
                      color: Color(0xFFBF360C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 32),

                  _section(
                    'Transliteration',
                    widget.mantra['transliteration']!,
                    Colors.indigo,
                  ),

                  _section(
                    isHindi ? 'अर्थ' : 'Meaning',
                    isHindi
                        ? widget.mantra['meaning_hi']!
                        : widget.mantra['meaning_en']!,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, String content, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            title,
            style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }
}
