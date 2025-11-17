import 'package:flutter/foundation.dart';
import '../models/scan_history_item.dart';
import '../services/storage_service.dart';
import '../services/drive_service.dart';

class ScanHistoryProvider with ChangeNotifier {
  List<ScanHistoryItem> _history = [];
  bool _isLoading = false;

  List<ScanHistoryItem> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _history = await StorageService.loadScanHistory();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addScan(ScanHistoryItem item) async {
    _history.insert(0, item);
    await StorageService.saveScanHistory(_history);
    notifyListeners();
  }

  Future<void> deleteScan(String id) async {
    _history.removeWhere((item) => item.id == id);
    await StorageService.saveScanHistory(_history);
    notifyListeners();
  }

  Future<bool> clearAllHistory() async {
    final success = await StorageService.clearAllData();
    if (success) {
      _history.clear();
      notifyListeners();
    }
    return success;
  }

  Future<bool> backupToGoogleDrive() async {
    _isLoading = true;
    notifyListeners();

    final success = await DriveService.backupToGoogleDrive(_history);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> syncFromGoogleDrive() async {
    _isLoading = true;
    notifyListeners();

    final syncedHistory = await DriveService.syncFromGoogleDrive();

    if (syncedHistory != null) {
      _history = syncedHistory;
      await StorageService.saveScanHistory(_history);

      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  ScanHistoryItem? getScanById(String id) {
    try {
      return _history.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
