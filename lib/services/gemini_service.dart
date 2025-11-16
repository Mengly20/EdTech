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

  static Future<String> sendMessage(String message, ScanResult? equipment) async {
    if (_model == null) {
      initialize();
    }

    try {
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
      }

      final content = [Content.text('$context\n\nUser: $message')];
      final response = await _model!.generateContent(content);

      return response.text ?? 'Sorry, I could not generate a response.';
    } catch (e) {
      print('Error sending message to Gemini: $e');
      return 'Sorry, an error occurred while processing your request.';
    }
  }

  static Future<String> askAboutEquipment(ScanResult equipment, String question) async {
    return sendMessage(question, equipment);
  }
}
