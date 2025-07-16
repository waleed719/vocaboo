import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String? _selectedLanguageCode;

  final List<Map<String, String>> _languages = [
    {'code': 'us', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'cn', 'name': 'Chinese'},
    {'code': 'jp', 'name': 'Japanese'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'sa', 'name': 'Arabic'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'in', 'name': 'Hindi'},
  ];

  List<Map<String, String>> get languages => _languages;

  void setSelectedLanguage(String code) {
    _selectedLanguageCode = code;
    notifyListeners();
  }

  String? get selectedLanguageCode => _selectedLanguageCode;

  String? get selectedLanguageName {
    final lang = _languages.firstWhere(
      (lang) => lang['code'] == _selectedLanguageCode,
      orElse: () => {},
    );
    return lang['name'];
  }

  void resetLanguage() {
    _selectedLanguageCode = null;
    notifyListeners();
  }
}
