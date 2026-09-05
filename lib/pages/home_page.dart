import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Ditambahkan untuk mengatur warna status bar
import 'package:image_picker/image_picker.dart';
import 'resep_page.dart';
import 'panduan_page.dart';
import 'output_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutputPage(
            imagePath: image.path,
          ),
        ),
      );
    }
  }

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OutputPage(
              imagePath: photo.path,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Gagal membuka kamera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengakses kamera: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF32303B); 
    final Color cardColor = const Color(0xFF1F1E26); 
    final Color textMuted = const Color(0xFF8E8D96); 
    final Color iconBlue = const Color(0xFF7C8BFE); 
    final Color iconRed = const Color(0xFFFF5E5E); 
    final Color iconYellow = const Color(0xFFFFD15C); 
    final Color iconGreen = const Color(0xFF4ADE80); 

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent, 
        statusBarIconBrightness: Brightness.light, 
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: iconBlue, width: 4),
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          color: iconBlue,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'DIETARY DIVERSITY\nCLASSIFICATION TOOL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'nunito',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Developed by\nBhismo Surya Atmaja',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'nunito',
                          color: textMuted,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildListButton(
                  icon: Icons.camera_alt_outlined,
                  iconColor: iconRed,
                  title: 'Activate Camera',
                  subtitle: 'Capture an image of your meal portion',
                  onTap: _openCamera,
                  cardColor: cardColor,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 16),
                _buildListButton(
                  icon: Icons.image_outlined,
                  iconColor: iconYellow,
                  title: 'Open Gallery',
                  subtitle: 'Select an image of your meal portion',
                  onTap: _openGallery,
                  cardColor: cardColor,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 16),
                _buildListButton(
                  icon: Icons.receipt_long_outlined,
                  iconColor: iconGreen,
                  title: 'Open Recipe Catalog',
                  subtitle: 'Browse the list of recipes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResepPage()),
                    );
                  },
                  cardColor: cardColor,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 16),
                _buildListButton(
                  icon: Icons.menu_book_outlined,
                  iconColor: iconBlue,
                  title: 'Open User Guide',
                  subtitle: 'Application overview',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PanduanPage()),
                    );
                  },
                  cardColor: cardColor,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListButton({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textMuted,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 20),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'nunito',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'nunito',
                        color: textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.chevron_right_rounded,
                color: textMuted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}