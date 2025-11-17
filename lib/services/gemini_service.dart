import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/constants.dart';
import '../models/scan_result.dart';

class GeminiService {
  static GenerativeModel? _model;

  static void initialize() {
    _model = GenerativeModel(
      model: ApiConstants.geminiModel,
      apiKey: ApiConstants.geminiApiKey,
    );
  }

  static Future<String> sendMessage(
      String message, ScanResult? equipment) async {
    if (_model == null) {
      print('⚠️ Gemini model not initialized, initializing now...');
      initialize();
    }

    try {
      print('🤖 ========== GEMINI API CALL ==========');

      // Build context
      String context = '';
      if (equipment != null) {
        context = '''
You are an educational AI assistant for a science equipment scanner app.
The user has scanned: ${equipment.nameEnglish} (${equipment.nameKhmer})
Category: ${equipment.category}
Usage: ${equipment.usage}

Please provide educational and helpful responses about this equipment.
''';
        print('📝 Context prepared:');
        print('   - Equipment: ${equipment.nameEnglish}');
        print('   - Category: ${equipment.category}');
      }

      final fullPrompt = '$context\n\nUser: $message';
      print('\n📡 API REQUEST:');
      print('🔑 Model: ${ApiConstants.geminiModel}');
      print(
          '🔑 API Key: ${ApiConstants.geminiApiKey.substring(0, 8)}...'); // Show first 8 chars only
      print('💬 User message: $message');
      print('📏 Full prompt length: ${fullPrompt.length} characters');
      print('📝 Full prompt:\n$fullPrompt');

      final content = [Content.text(fullPrompt)];

      print('\n⏳ Sending request to Gemini...');
      final startTime = DateTime.now();
      final response = await _model!.generateContent(content);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      print('\n📥 API RESPONSE:');
      print('⏱️ Response time: ${duration}ms');

      final responseText =
          response.text ?? 'Sorry, I could not generate a response.';
      print('📄 Response length: ${responseText.length} characters');
      print('📝 Response text: $responseText');
      print('✅ Gemini response received successfully');
      print('========== GEMINI API COMPLETE ==========\n');

      return responseText;
    } catch (e, stackTrace) {
      print('❌ ========== GEMINI API ERROR ==========');
      print('Error sending message to Gemini: $e');
      print('Stack trace: $stackTrace');
      print('========================================\n');
      return 'Sorry, an error occurred while processing your request.';
    }
  }

  static Future<String> askAboutEquipment(
      ScanResult equipment, String question) async {
    return sendMessage(question, equipment);
  }
}
