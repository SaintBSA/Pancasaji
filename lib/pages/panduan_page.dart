import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PanduanPage extends StatelessWidget {
  const PanduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Palet Warna
    final Color bgColor = const Color(0xFF32303B);
    final Color cardColor = const Color(0xFF1F1E26);
    final Color textMuted = const Color(0xFF8E8D96);
    final Color iconBlue = const Color(0xFF7C8BFE);
    final Color iconYellow = const Color(0xFFFFD15C);

    // --- 1. TUJUAN APLIKASI ---
    const String textTujuan = 
        'This application serves as a supporting tool in the joint effort to prevent stunting. '
        'We hope this application can help you understand the nutritional completeness of your child\'s daily food plate. '
        'Our main goal is to increase public awareness regarding the importance of good nutrition, '
        'in line with the targets of the Indonesian Ministry of Health.';

    // --- 2. FITUR APLIKASI ---
    const String textFitur = 
        'On the main page, you will find the features available in the application\n\n'
        '• Camera & Gallery: Use to take or select a photo of your food plate.\n'
        '• Smart Analysis: Once a photo is selected, our artificial intelligence (AI) will analyze its nutritional completeness in a short time (3-5 seconds).\n'
        '• Recipe Catalog: Find various healthy menu inspirations that are easy to make.\n'
        '• Guide: This page, which is always ready to guide you anytime.';

    // --- 3. REKOMENDASI GIZI IBU HAMIL ---
    const String textGiziBumil = 
        'Good maternal nutrition includes meeting nutritional needs before pregnancy, during pregnancy, and while breastfeeding. During this phase, daily nutritional needs will increase significantly.\n\n'
        'To prevent low birth weight and stunting, here are recommendations that can be applied:\n'
        '• Consume a diverse food diet that includes at least 5 food groups every day.\n'
        '• Ensure the consumption of Iron and Folic Acid supplements or multiple micronutrients as recommended.\n'
        '• Maintain adequate weight gain according to your physical condition.\n'
        '• Do appropriate physical activities regularly.';

    // --- 4. CITRA LAYAK ---
    const String textCitraLayak = 
        'For the system to function properly, ensure the photo meets the criteria:\n\n'
        '• Food is arranged clearly and does not overlap.\n'
        '• The photo is taken perpendicularly (straight from above the plate).\n'
        '• Sufficiently bright lighting.\n'
        '• The image looks sharp (not blurry).';

    // --- 5. CITRA TIDAK LAYAK ---
    const String textCitraTidakLayak = 
        'The artificial intelligence might struggle to recognize food if:\n\n'
        '• Food placement overlaps and covers one another.\n'
        '• Taking photos from a tilted angle or from the side.\n'
        '• Lighting is too dark or too bright.\n'
        '• The photo looks blurry.';

    // --- 6. BATASAN APLIKASI ---
    const String textBatasan = 
        'This application is designed as a supporting tool to classify nutritional components on a plate and increase visual awareness.\n\n'
        'IMPORTANT: This application does not replace medical diagnosis, doctor\'s advice, or nutritionists. Full awareness and nutritional intake decisions remain with you as a parent. If you have any doubts regarding health conditions, pregnancy, or child nutrition, always consult a healthcare professional.';

    final List<String> layakImages = [
      'lib/assets/Citralayak1.jpg',
      'lib/assets/Citralayak2.jpg',
      'lib/assets/Citralayak3.jpg',
      'lib/assets/Citralayak4.jpg',
    ];

    final List<String> tidakLayakImages = [
      'lib/assets/Citratidaklayak1.jpg',
      'lib/assets/Citratidaklayak2.jpg',
      'lib/assets/Citratidaklayak3.jpg',
      'lib/assets/Citratidaklayak4.jpg',
    ];

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
                    Material(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),

                    Material(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse('https://wa.me/082132053799');
                          try {
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              throw Exception('Could not open the link');
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Failed to open feedback link',
                                    style: TextStyle(fontFamily: 'nunito', color: Colors.white),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.chat_outlined, color: iconYellow, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Give Feedback',
                                style: TextStyle(
                                  fontFamily: 'nunito',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Column(
                    children: [
                      // 1. TUJUAN
                      _buildGuideCard(
                        context: context,
                        number: '1',
                        title: 'Application Purpose',
                        bodyText: textTujuan,
                        iconBlue: iconBlue,
                        cardColor: cardColor,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 20),

                      // 2. FITUR
                      _buildGuideCard(
                        context: context,
                        number: '2',
                        title: 'Application Features',
                        bodyText: textFitur,
                        iconBlue: iconBlue,
                        cardColor: cardColor,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 20),

                      // 3. REKOMENDASI GIZI (BARU)
                      _buildGuideCard(
                        context: context,
                        number: '3',
                        title: 'Nutritional Recommendations',
                        bodyText: textGiziBumil,
                        iconBlue: iconBlue,
                        cardColor: cardColor,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 20),

                      // 4. CITRA LAYAK
                      _buildGuideCard(
                        context: context,
                        number: '4',
                        title: 'Ideal Image Guide',
                        bodyText: textCitraLayak,
                        iconBlue: iconBlue,
                        cardColor: cardColor,
                        textMuted: textMuted,
                        imagePaths: layakImages, 
                      ),
                      const SizedBox(height: 20),

                      // 5. CITRA TIDAK LAYAK
                      _buildGuideCard(
                        context: context,
                        number: '5',
                        title: 'Avoid These Photos',
                        bodyText: textCitraTidakLayak,
                        iconBlue: iconBlue,
                        cardColor: cardColor,
                        textMuted: textMuted,
                        imagePaths: tidakLayakImages, 
                      ),
                      const SizedBox(height: 20),

                      // 6. BATASAN APLIKASI (BARU)
                      _buildGuideCard(
                        context: context,
                        number: '6',
                        title: 'Application Limitations',
                        bodyText: textBatasan,
                        iconBlue: iconBlue,
                        cardColor: cardColor,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required BuildContext context,
    required String number,
    required String title,
    required String bodyText,
    required Color iconBlue,
    required Color cardColor,
    required Color textMuted,
    List<String>? imagePaths,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      fontFamily: 'nunito',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'nunito',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            bodyText,
            style: TextStyle(
              fontFamily: 'nunito',
              color: textMuted,
              fontSize: 13,
              height: 1.6,
            ),
          ),

          if (imagePaths != null && imagePaths.isNotEmpty) ...[
            const SizedBox(height: 20),
            for (int i = 0; i < imagePaths.length; i += 2)
              Padding(
                padding: EdgeInsets.only(bottom: i + 2 < imagePaths.length ? 16.0 : 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildClickableImage(context, imagePaths[i]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: i + 1 < imagePaths.length
                          ? _buildClickableImage(context, imagePaths[i + 1])
                          : const SizedBox(), 
                    ),
                  ],
                ),
              ),
          ]
        ],
      ),
    );
  }

  Widget _buildClickableImage(BuildContext context, String imagePath) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showExpandedImage(context, imagePath),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3B3A44), width: 1.5), 
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showExpandedImage(BuildContext context, String imagePath) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      barrierDismissible: true, 
      barrierLabel: 'Close Image',
      transitionDuration: const Duration(milliseconds: 300), 
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              Positioned(
                top: 20,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1E26).withOpacity(0.8), 
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            )),
            child: child,
          ),
        );
      },
    );
  }
}