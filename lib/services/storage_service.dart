import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_history_item.dart';
import '../utils/constants.dart';

class StorageService {
  static Future<List<ScanHistoryItem>> loadScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(ApiConstants.scanHistoryKey);

      if (historyJson != null && historyJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        return decoded
            .map((item) => ScanHistoryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error loading scan history: $e');
      return [];
    }
  }

  static Future<bool> saveScanHistory(List<ScanHistoryItem> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList =
          history.map((item) => item.toJson()).toList();
      final String historyJson = jsonEncode(jsonList);

      return await prefs.setString(ApiConstants.scanHistoryKey, historyJson);
    } catch (e) {
      print('Error saving scan history: $e');
      return false;
    }
  }

  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(ApiConstants.scanHistoryKey);
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }

  static Future<String> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(ApiConstants.languageKey) ?? 'en';
    } catch (e) {
      print('Error getting language: $e');
      return 'en';
    }
  }

  static Future<bool> setLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(ApiConstants.languageKey, language);
    } catch (e) {
      print('Error setting language: $e');
      return false;
    }
  }
}
