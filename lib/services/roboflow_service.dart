import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/equipment_database.dart';
import '../models/scan_result.dart';

class RoboflowService {
  static Future<ScanResult?> analyzeImage(File imageFile) async {
    try {
      print('🤖 ========== ROBOFLOW API CALL ==========');

      // Read image bytes
      print('📖 Reading image file...');
      final imageBytes = await imageFile.readAsBytes();
      print('✅ Image read: ${imageBytes.length} bytes');

      print('🔄 Encoding image to base64...');
      final base64Image = base64Encode(imageBytes);
      print('✅ Base64 encoded: ${base64Image.length} characters');

      // Prepare API request with data URI prefix (matching React Native implementation)
      final url = Uri.parse(ApiConstants.roboflowWorkflowUrl);
      final base64WithPrefix = 'data:image/jpeg;base64,$base64Image';
      print('📦 Adding data URI prefix: data:image/jpeg;base64,...');

      // Create request body
      final requestBody = {
        'api_key': ApiConstants.roboflowApiKey,
        'inputs': {
          'image': {
            'type': 'base64',
            'value': base64WithPrefix,
          }
        }
      };

      final requestBodyJson = jsonEncode(requestBody);

      print('\n📡 API REQUEST:');
      print('🔗 URL: ${ApiConstants.roboflowWorkflowUrl}');
      print(
          '🔑 API Key: ${ApiConstants.roboflowApiKey.substring(0, 8)}...'); // Show first 8 chars only
      print('📦 Content-Type: application/json');
      print('📏 Body structure:');
      print('   - api_key: ${ApiConstants.roboflowApiKey.substring(0, 8)}...');
      print('   - inputs.image.type: base64');
      print('   - inputs.image.value: data:image/jpeg;base64,...');
      print(
          '   - inputs.image.value length: ${base64WithPrefix.length} characters');
      print('📦 Request body length: ${requestBodyJson.length} bytes');

      // Send request
      print('\n⏳ Sending request to Roboflow Workflow...');
      final startTime = DateTime.now();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      print('\n📥 API RESPONSE:');
      print('⏱️ Response time: ${duration}ms');
      print('📊 Status code: ${response.statusCode}');
      print('📋 Response headers: ${response.headers}');
      print('📄 Response body length: ${response.body.length} characters');
      print('📝 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('\n✅ Response successful, parsing data...');
        final data = jsonDecode(response.body);
        print('📦 Parsed JSON structure: ${data.keys.toList()}');
        print('📦 Full JSON: $data');

        // Handle workflow response - check for outputs first
        dynamic predictions;

        if (data['outputs'] != null) {
          print('\n📤 Found workflow outputs');
          // Workflow API returns outputs array
          final outputs = data['outputs'] as List;
          if (outputs.isNotEmpty) {
            final firstOutput = outputs[0];
            print('📊 First output keys: ${firstOutput.keys.toList()}');

            // Try to find predictions in various possible locations
            if (firstOutput['predictions'] != null) {
              predictions = firstOutput['predictions'];
              print('✅ Found predictions in outputs[0].predictions');
            } else if (firstOutput['output'] != null &&
                firstOutput['output']['predictions'] != null) {
              predictions = firstOutput['output']['predictions'];
              print('✅ Found predictions in outputs[0].output.predictions');
            }
          }
        } else if (data['predictions'] != null) {
          // Legacy API format
          predictions = data['predictions'];
          print('✅ Found predictions in root level (legacy format)');
        }

        // Check if predictions exist
        if (predictions != null) {
          print('\n🎯 Predictions object type: ${predictions.runtimeType}');
          print('📦 Predictions content: $predictions');

          // Handle different prediction formats
          dynamic predictionList;

          if (predictions is List) {
            print('✅ Predictions is a List with ${predictions.length} items');
            predictionList = predictions;
          } else if (predictions is Map) {
            print('✅ Predictions is a Map with ${predictions.length} keys');
            print('🔑 Map keys: ${predictions.keys.toList()}');

            // Try to find predictions in common map keys
            if (predictions.containsKey('predictions')) {
              predictionList = predictions['predictions'];
              print('📍 Found predictions in map["predictions"]');
            } else if (predictions.containsKey('detections')) {
              predictionList = predictions['detections'];
              print('📍 Found predictions in map["detections"]');
            } else {
              // Maybe the map itself contains the prediction data
              print('📍 Using map as single prediction');
              predictionList = [predictions];
            }
          } else {
            print('❌ Unknown predictions format: ${predictions.runtimeType}');
            return null;
          }

          if (predictionList == null ||
              (predictionList is List && predictionList.isEmpty)) {
            print('❌ No predictions in list');
            return null;
          }

          print(
              '\n🎯 Processing ${predictionList is List ? predictionList.length : 1} prediction(s)');

          // Find the first valid prediction
          dynamic prediction;
          if (predictionList is List) {
            for (int i = 0; i < predictionList.length; i++) {
              print('🔍 Prediction $i: ${predictionList[i]}');
              if (predictionList[i] != null &&
                  predictionList[i] is Map &&
                  predictionList[i]['class'] != null) {
                prediction = predictionList[i];
                print('✅ Found valid prediction at index $i');
                break;
              }
            }
          } else if (predictionList is Map && predictionList['class'] != null) {
            prediction = predictionList;
            print('✅ Using single prediction map');
          }

          if (prediction == null) {
            print('❌ No valid predictions found with class field');
            return null;
          }

          print('\n✅ Valid prediction: $prediction');

          final detectedClassRaw = prediction['class'] as String;
          final confidence = (prediction['confidence'] as num).toDouble();

          // Convert class name to lowercase to match database format
          final detectedClass = detectedClassRaw.toLowerCase();

          print('📌 Detected class (raw): $detectedClassRaw');
          print('📌 Detected class (normalized): $detectedClass');
          print('💯 Confidence: ${(confidence * 100).toStringAsFixed(2)}%');

          // Get equipment info from database
          print('\n🗄️ Looking up equipment in database...');
          final equipment =
              EquipmentDatabase.getEquipmentByClass(detectedClass);

          if (equipment != null) {
            print('✅ Equipment found in database:');
            print('   - English: ${equipment.nameEnglish}');
            print('   - Khmer: ${equipment.nameKhmer}');
            print('   - Category: ${equipment.category}');
            print('========== ROBOFLOW API COMPLETE ==========\n');

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
          } else {
            print(
                '❌ Equipment not found in database for class: $detectedClass');
          }
        } else {
          print('❌ No predictions found in response');
          print('📝 Response structure: $data');
        }
      } else {
        print('❌ API request failed with status code: ${response.statusCode}');
        print('📝 Error body: ${response.body}');
      }

      print('========== ROBOFLOW API COMPLETE (NO RESULT) ==========\n');
      return null;
    } catch (e, stackTrace) {
      print('❌ ========== ROBOFLOW API ERROR ==========');
      print('Error analyzing image: $e');
      print('Stack trace: $stackTrace');
      print('========================================\n');
      return null;
    }
  }
}
