import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  int _currentTabIndex = 0;
  bool _isScanning = false;

  int get currentTabIndex => _currentTabIndex;
  bool get isScanning => _isScanning;

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void setScanning(bool scanning) {
    if (_isScanning != scanning) {
      _isScanning = scanning;
      notifyListeners();
    }
  }
}
