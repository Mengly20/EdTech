import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/equipment_database.dart';
import '../models/scan_result.dart';

class RoboflowService {
  static Future<ScanResult?> analyzeImage(File imageFile) async {
    try {
      // Read image bytes
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare API request
      final url = Uri.parse(
        '${ApiConstants.roboflowModelUrl}?api_key=${ApiConstants.roboflowApiKey}&confidence=40',
      );

      // Send request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: base64Image,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check if predictions exist
        if (data['predictions'] != null && data['predictions'].isNotEmpty) {
          final prediction = data['predictions'][0];
          final detectedClass = prediction['class'] as String;
          final confidence = (prediction['confidence'] as num).toDouble();

          // Get equipment info from database
          final equipment = EquipmentDatabase.getEquipmentByClass(detectedClass);

          if (equipment != null) {
            return ScanResult(
              nameKhmer: equipment.nameKhmer,
              nameEnglish: equipment.nameEnglish,
              confidence: confidence,
              category: equipment.category,
              categoryKhmer: equipment.categoryKhmer,
              usage: equipment.usage,
              detectedClass: detectedClass,
              tags: equipment.tags,
            );
          }
        }
      }

      return null;
    } catch (e) {
      print('Error analyzing image: $e');
      return null;
    }
  }
}
