import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResepDetailPage extends StatefulWidget {
  final String title;
  final String duration;
  final List<String> bahan;
  final List<String> langkah;
  
  final bool initialFavorite; 
  final VoidCallback onFavoriteToggle; 

  const ResepDetailPage({
    super.key,
    required this.title,
    required this.duration,
    required this.bahan,
    required this.langkah,
    required this.initialFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<ResepDetailPage> createState() => _ResepDetailPageState();
}

class _ResepDetailPageState extends State<ResepDetailPage> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.initialFavorite;
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Palet Warna
    final Color bgColor = const Color(0xFF32303B);
    final Color cardColor = const Color(0xFF1F1E26);
    final Color textMuted = const Color(0xFF8E8D96);
    final Color iconYellow = const Color(0xFFFFD15C);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          isFavorited = !isFavorited; // Ubah tampilan ikon di halaman ini
                        });
                        widget.onFavoriteToggle(); // Beri tahu halaman utama untuk menyimpan perubahannya!
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isFavorited ? Icons.bookmark : Icons.bookmark_border_rounded,
                          color: iconYellow,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'nunito',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.duration,
                          style: TextStyle(
                            fontFamily: 'nunito',
                            color: textMuted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 32),

                        const Text(
                          "Bahan Yang Dibutuhkan",
                          style: TextStyle(fontFamily: 'nunito', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.bahan.asMap().entries.map((entry) {
                            int idx = entry.key + 1;
                            String val = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "$idx. $val",
                                style: TextStyle(fontFamily: 'nunito', color: textMuted, fontSize: 13, height: 1.5),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          "Cara Pembuatan",
                          style: TextStyle(fontFamily: 'nunito', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.langkah.asMap().entries.map((entry) {
                            int idx = entry.key + 1;
                            String val = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$idx. ",
                                    style: TextStyle(fontFamily: 'nunito', color: textMuted, fontSize: 13, height: 1.5),
                                  ),
                                  Expanded(
                                    child: Text(
                                      val,
                                      style: TextStyle(fontFamily: 'nunito', color: textMuted, fontSize: 13, height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}