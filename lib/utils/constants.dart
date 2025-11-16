class ApiConstants {
  // Roboflow API Configuration
  static const String roboflowApiKey = 'YOUR_ROBOFLOW_API_KEY';
  static const String roboflowModelUrl = 'https://detect.roboflow.com/YOUR_MODEL/1';
  
  // Google Gemini AI Configuration
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String geminiModel = 'gemini-1.5-flash';
  
  // Google OAuth Configuration (Optional - for Google Drive)
  static const String googleClientId = 'YOUR_CLIENT_ID.apps.googleusercontent.com';
  
  // Storage Keys
  static const String scanHistoryKey = 'edtech_scan_history';
  static const String languageKey = 'app_language';
}

class AppConstants {
  static const String appName = 'EdTech Science Scanner';
  static const String appVersion = '1.0.0';
  
  // Supported Languages
  static const String languageEnglish = 'en';
  static const String languageKhmer = 'km';
}
