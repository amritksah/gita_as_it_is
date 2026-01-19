import 'package:flutter/material.dart';
import '../data/mantras_data.dart';
import 'mantra_detail_page.dart';

class MantraListPage extends StatelessWidget {
  final String category;

  const MantraListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final list =
        mantrasData.where((m) => m['category'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
        backgroundColor: const Color(0xFF512DA8),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final mantra = list[index];

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(mantra['title']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MantraDetailPage(mantra: mantra),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
