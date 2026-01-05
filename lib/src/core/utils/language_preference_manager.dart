import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferenceManager extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  final SharedPreferences _preferences;
  String _currentLanguage = 'ar';
  bool _isInitialized = false;

  LanguagePreferenceManager(this._preferences) {
    _initializeLanguage();
  }

  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;

  Future<void> _initializeLanguage() async {
    final savedLanguage = _preferences.getString(_languageKey);
    
    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      _currentLanguage = savedLanguage;
    } else {
      // If no saved language, default to Arabic
      _currentLanguage = 'ar';
    }
    
    _isInitialized = true;
    notifyListeners();
  }
  
  Future<String> getCurrentLanguage() async {
    if (!_isInitialized) {
      await _initializeLanguage();
    }
    return _currentLanguage;
  }
  
  Future<void> setLanguage(String languageCode) async {
    await _preferences.setString(_languageKey, languageCode);
    _currentLanguage = languageCode;
    notifyListeners();
  }
  
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }
}

