import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = AppConstants.languageEnglish;

  String get currentLanguage => _currentLanguage;

  Future<void> loadLanguage() async {
    _currentLanguage = await StorageService.getLanguage();
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (language == _currentLanguage) return;
    
    _currentLanguage = language;
    await StorageService.setLanguage(language);
    notifyListeners();
  }

  void toggleLanguage() {
    final newLanguage = _currentLanguage == AppConstants.languageEnglish
        ? AppConstants.languageKhmer
        : AppConstants.languageEnglish;
    setLanguage(newLanguage);
  }

  String translate(String key, Map<String, Map<String, String>> translations) {
    return translations[_currentLanguage]?[key] ?? 
           translations[AppConstants.languageEnglish]?[key] ?? 
           key;
  }
}
