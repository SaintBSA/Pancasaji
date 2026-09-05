import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_vision/flutter_vision.dart';

class OutputPage extends StatefulWidget {
  final String imagePath;

  const OutputPage({super.key, required this.imagePath});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  late FlutterVision vision;
  bool isLoading = true;

  // --- VARIABLES ---
  bool adaNasi = false;
  bool adaProteinHewani = false;
  bool adaProteinNabati = false;
  bool adaSayurAirSerat = false;
  bool adaSayurDaunHijau = false;
  
  List<Map<String, dynamic>> yoloResults = [];
  Map<String, double> nutrientPercentages = {
    'rice': 0.0,
    'animal protein': 0.0,
    'plant-based protein': 0.0,
    'water fibre vegetable': 0.0,
    'green leaf vegetable': 0.0,
  };
  
  bool _showBoundingBox = true;

  double imageWidth = 0;
  double imageHeight = 0;

  final Color bgColor = const Color(0xFF32303B);
  final Color cardColor = const Color(0xFF1F1E26);
  final Color textMuted = const Color(0xFF8E8D96);
  final Color iconBlue = const Color(0xFF7C8BFE);
  final Color textGreen = const Color(0xFF4ADE80);
  final Color textRed = const Color(0xFFFF5E5E);
  final Color btnYellow = const Color(0xFFFFD15C);

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    _prosesGambarDenganAI();
  }

  Future<void> _prosesGambarDenganAI() async {
    try {
      await vision.loadYoloModel(
        labels: 'assets/models/labels.txt',
        modelPath: 'assets/models/best_float32.tflite',
        modelVersion: "yolov8", 
        numThreads: 2,
        useGpu: false,
      );

      File imageFile = File(widget.imagePath);
      Uint8List imageBytes = await imageFile.readAsBytes();
      final image = await decodeImageFromList(imageBytes);

      final result = await vision.yoloOnImage(
        bytesList: imageBytes,
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.4,
        confThreshold: 0.2, 
        classThreshold: 0.2,
      );

      // --- PORTION MEASUREMENT LOGIC ---
      double totalDetectedArea = 0.0;
      Map<String, double> tempAreas = {
        'rice': 0.0, 
        'animal protein': 0.0, 
        'plant-based protein': 0.0,
        'water fibre vegetable': 0.0, 
        'green leaf vegetable': 0.0
      };

      for (var res in result) {
        List<dynamic> box = res['box'];
        
        // Calculate the area of the current bounding box: width * height
        double width = (box[2] as num).toDouble() - (box[0] as num).toDouble();
        double height = (box[3] as num).toDouble() - (box[1] as num).toDouble();
        double area = width * height;
        
        String tag = res['tag'].toString().toLowerCase().trim();
        
        // If there are multiple bounding boxes of the same type, their areas add up
        if (tempAreas.containsKey(tag)) {
          tempAreas[tag] = tempAreas[tag]! + area;
          totalDetectedArea += area;
        }
      }

      if (mounted) {
        setState(() {
          yoloResults = result;
          imageWidth = image.width.toDouble();
          imageHeight = image.height.toDouble();
          
          // Calculate the percentage of each component relative to the total detected food area
          nutrientPercentages = tempAreas.map((key, value) => 
              MapEntry(key, totalDetectedArea > 0 ? (value / totalDetectedArea) * 100 : 0.0));
          
          adaNasi = (nutrientPercentages['rice'] ?? 0) > 0;
          adaProteinHewani = (nutrientPercentages['animal protein'] ?? 0) > 0;
          adaProteinNabati = (nutrientPercentages['plant-based protein'] ?? 0) > 0;
          adaSayurAirSerat = (nutrientPercentages['water fibre vegetable'] ?? 0) > 0;
          adaSayurDaunHijau = (nutrientPercentages['green leaf vegetable'] ?? 0) > 0;
          
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error running AI: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    vision.closeYoloModel();
    super.dispose();
  }

  Future<void> _saveScreenshot() async {
    try {
      final directory = await getTemporaryDirectory();
      final String fileName =
          'detection_result_${DateTime.now().millisecondsSinceEpoch}.png';

      await screenshotController.captureAndSave(
        directory.path,
        fileName: fileName,
      );

      final String fullPath = '${directory.path}/$fileName';
      await Gal.putImage(fullPath);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cardColor,
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.up,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 120,
              left: 24,
              right: 24,
            ),
            elevation: 0,
            duration: const Duration(milliseconds: 2500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: textGreen, width: 1.5),
            ),
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: textGreen),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Successfully saved to gallery!',
                    style: TextStyle(
                      fontFamily: 'nunito',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error saving: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cardColor,
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.up,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 160,
              left: 24,
              right: 24,
            ),
            elevation: 0,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: textRed, width: 1.5),
            ),
            content: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: textRed),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Failed to save: $e',
                    style: const TextStyle(
                      fontFamily: 'nunito',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int score = 0;
    List<String> missingComponents = [];

    if (adaNasi) score++; else missingComponents.add("Rice");
    if (adaProteinHewani) score++; else missingComponents.add("Animal Protein");
    if (adaProteinNabati) score++; else missingComponents.add("Plant-Based Protein");
    if (adaSayurDaunHijau) score++; else missingComponents.add("Green Leaf Vegetables");
    if (adaSayurAirSerat) score++; else missingComponents.add("Water Fibre Vegetables");

    String verdictTitle;
    String verdictSubtitle;
    Color verdictColor;

    if (score == 5) {
      verdictTitle = "COMPLETE (100%)";
      verdictSubtitle = "Good Job! All 5 components are present.";
      verdictColor = textGreen;
    } else {
      int percentage = score * 20;
      verdictTitle = "NOT COMPLETE ($percentage%)";
      verdictSubtitle = "Missing: ${missingComponents.join(', ')}";
      verdictColor = btnYellow; 
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: iconBlue),
                      const SizedBox(height: 16),
                      const Text(
                        'Model is analyzing the image..',
                        style: TextStyle(
                          fontFamily: 'nunito',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // --- APP BAR ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
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
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: _saveScreenshot,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.download_rounded,
                                      color: btnYellow,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Save Result',
                                      style: TextStyle(
                                        fontFamily: 'nunito',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
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

                    // --- SCREENSHOT AREA ---
                    Expanded(
                      child: Screenshot(
                        controller: screenshotController,
                        child: Container(
                          color: bgColor,
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: iconBlue, width: 2),
                                            ),
                                            child: Icon(
                                              Icons.restaurant_menu,
                                              color: iconBlue,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'DIETARY DIVERSITY\nCLASSIFICATION TOOL',
                                            style: TextStyle(
                                              fontFamily: 'nunito',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      Expanded(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: CustomPaint(
                                                  foregroundPainter: yoloResults.isNotEmpty && imageWidth > 0 && _showBoundingBox
                                                      ? BoundingBoxPainter(yoloResults, Size(imageWidth, imageHeight))
                                                      : null,
                                                  child: Image.file(
                                                    File(widget.imagePath),
                                                    fit: BoxFit.contain, 
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (yoloResults.isNotEmpty) 
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Material(
                                                  color: cardColor.withOpacity(0.85),
                                                  shape: const CircleBorder(),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _showBoundingBox = !_showBoundingBox;
                                                      });
                                                    },
                                                    customBorder: const CircleBorder(),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        _showBoundingBox 
                                                          ? Icons.visibility_rounded 
                                                          : Icons.visibility_off_rounded,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      Text(
                                        'Classification Result',
                                        style: TextStyle(
                                          fontFamily: 'nunito',
                                          color: textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        verdictTitle,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'nunito',
                                          color: verdictColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        verdictSubtitle,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'nunito',
                                          color: Colors.white,
                                          fontSize: 13,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // --- COMPONENT LIST WITH PORTION MEASUREMENT ---
                              _buildNutrientRow('RICE', 'rice'),
                              const SizedBox(height: 10),
                              _buildNutrientRow('ANIMAL PROTEIN', 'animal protein'),
                              const SizedBox(height: 10),
                              _buildNutrientRow('PLANT-BASED PROTEIN', 'plant-based protein'),
                              const SizedBox(height: 10),
                              _buildNutrientRow('GREEN LEAF VEGETABLES', 'green leaf vegetable'),
                              const SizedBox(height: 10),
                              _buildNutrientRow('WATER FIBRE VEGETABLES', 'water fibre vegetable'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String mapKey) {
    double percentage = nutrientPercentages[mapKey] ?? 0.0;
    bool isDetected = percentage > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'nunito',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isDetected) ...[
                const SizedBox(height: 2),
                Text(
                  "Portion: ${percentage.toStringAsFixed(1)}% of plate",
                  style: TextStyle(
                    fontFamily: 'nunito',
                    color: textMuted,
                    fontSize: 12,
                  ),
                ),
              ]
            ],
          ),
          Text(
            isDetected ? 'Detected' : 'Not Detected',
            style: TextStyle(
              fontFamily: 'nunito',
              color: isDetected ? textGreen : textRed,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> results;
  final Size imageOriginalSize;

  BoundingBoxPainter(this.results, this.imageOriginalSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (imageOriginalSize == Size.zero) return;

    double scaleX = size.width / imageOriginalSize.width;
    double scaleY = size.height / imageOriginalSize.height;
    double scale = scaleX < scaleY ? scaleX : scaleY; 

    double dx = (size.width - (imageOriginalSize.width * scale)) / 2;
    double dy = (size.height - (imageOriginalSize.height * scale)) / 2;

    for (var res in results) {
      List<dynamic> box = res['box'];
      String tag = res['tag'].toString().trim().toLowerCase();

      double left = ((box[0] as num).toDouble() * scale) + dx;
      double top = ((box[1] as num).toDouble() * scale) + dy;
      double right = ((box[2] as num).toDouble() * scale) + dx;
      double bottom = ((box[3] as num).toDouble() * scale) + dy;

      Color boxColor = Colors.grey; 
      String displayLabel = "Unknown";

      // MATCHING EXACT ENGLISH STRINGS
      if (tag == 'rice') {
        boxColor = const Color(0xFFFBBF24); 
        displayLabel = "Rice";
      } else if (tag == 'animal protein') {
        boxColor = const Color(0xFFFF5E5E); 
        displayLabel = "Animal Protein";
      } else if (tag == 'plant-based protein') {
        boxColor = const Color(0xFFF97316); 
        displayLabel = "Plant-Based Protein";
      } else if (tag == 'green leaf vegetable') {
        boxColor = const Color(0xFF4ADE80); 
        displayLabel = "Green Leaf Vegetables";
      } else if (tag == 'water fibre vegetable') {
        boxColor = const Color(0xFF7C8BFE); 
        displayLabel = "Water Fibre Vegetables";
      }

      final paintBox = Paint()
        ..color = boxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paintBox);

      final textSpan = TextSpan(
        text: displayLabel,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          fontFamily: 'nunito',
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final bgPaint = Paint()..color = boxColor;
      canvas.drawRect(
        Rect.fromLTWH(
          left,
          top - textPainter.height - 4,
          textPainter.width + 8,
          textPainter.height + 4,
        ),
        bgPaint,
      );

      textPainter.paint(canvas, Offset(left + 4, top - textPainter.height - 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}