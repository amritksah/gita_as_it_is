import 'package:flutter/material.dart';
import '../models/verse_model.dart';
import '../utils/read_progress.dart';
import '../utils/favorites_manager.dart'; // ❤️ ADD

class VerseDetailPage extends StatefulWidget {
  final List<Verse> verses;
  final int currentIndex;
  final int chapterNumber;
  final Set<int> readVerses;

  const VerseDetailPage({
    super.key,
    required this.verses,
    required this.currentIndex,
    required this.chapterNumber,
    required this.readVerses,
  });

  @override
  State<VerseDetailPage> createState() => _VerseDetailPageState();
}

class _VerseDetailPageState extends State<VerseDetailPage> {
  late int index;
  bool isHindi = false;

  final ScrollController _scrollController = ScrollController();
  bool markedRead = false;

  // ❤️ FAVORITE STATE
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    index = widget.currentIndex;

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfScrollable();
      _loadFavoriteStatus();
    });
  }

  // 🔑 Current verse getter
  Verse get verse => widget.verses[index];

  String get verseKey =>
      'BG-${widget.chapterNumber}-${verse.number}';

  // ❤️ Load favorite state
  Future<void> _loadFavoriteStatus() async {
    isFavorite = await FavoritesManager.isFavorite(verseKey);
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 20) {
      _markVerseAsRead();
    }
  }

  void _checkIfScrollable() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.maxScrollExtent == 0) {
      _markVerseAsRead();
    }
  }

  /// ✅ Marks verse read + saves permanently
  void _markVerseAsRead() {
    if (markedRead) return;

    final verseNumber = verse.number;
    widget.readVerses.add(verseNumber);

    // 💾 SAVE READ PROGRESS
    ReadProgress.saveVerse(widget.chapterNumber, verseNumber);

    markedRead = true;
  }

  Widget section({
    required String title,
    required String content,
    required Color titleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _goNext() {
    if (index < widget.verses.length - 1) {
      setState(() {
        index++;
        markedRead = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(0);
        _checkIfScrollable();
        _loadFavoriteStatus();
      });
    }
  }

  void _goBack() {
    if (index > 0) {
      setState(() {
        index--;
        markedRead = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(0);
        _checkIfScrollable();
        _loadFavoriteStatus();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationText =
        isHindi ? verse.translationHi ?? verse.translation : verse.translation;

    final purportText =
        isHindi ? verse.purportHi ?? verse.purport : verse.purport;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      appBar: AppBar(
        title: Text(
          'BG ${widget.chapterNumber}.${verse.number}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF512DA8),
        foregroundColor: Colors.white,
        actions: [
          // 🌐 LANGUAGE TOGGLE
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: isHindi ? 'English' : 'Hindi',
            onPressed: () => setState(() => isHindi = !isHindi),
          ),

          // ❤️ FAVORITE BUTTON
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.white,
            ),
            onPressed: () async {
              if (isFavorite) {
                await FavoritesManager.remove(verseKey);
              } else {
                await FavoritesManager.add(verseKey);
              }

              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🕉 Sanskrit
                  Text(
                    verse.sanskrit,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.7,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFBF360C),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  section(
                    title: 'Transliteration',
                    content: verse.transliteration,
                    titleColor: Colors.indigo,
                  ),

                  section(
                    title: 'Word-to-Word Meaning',
                    content: verse.wordMeanings,
                    titleColor: Colors.teal,
                  ),

                  section(
                    title: isHindi ? 'अनुवाद' : 'Translation',
                    content: translationText,
                    titleColor: Colors.green,
                  ),

                  section(
                    title: isHindi ? 'तात्पर्य' : 'Purport',
                    content: purportText,
                    titleColor: Colors.deepPurple,
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                        onPressed: index > 0 ? _goBack : null,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        onPressed:
                            index < widget.verses.length - 1 ? _goNext : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
