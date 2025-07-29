import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vocaboo/screens/account_process/login_screen.dart';

class UserProvider with ChangeNotifier {
  String? _id;
  String? _username;
  String? _email;
  String? _language;
  int _stars = 0;
  int _hoursspent = 0;
  String? _profilepicture;
  int _grammarLevel = 0;
  int _vocabularyLevel = 0;
  int _listeningLevel = 0;
  int _speakingLevel = 0;

  final supabase = Supabase.instance.client;
  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return;
    }
    final response =
        await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.id)
            .single();

    _id = user.id;
    _email = user.email;
    _username = response['username'];
    _language = response['learning_language'];
    _stars = response['stars'];
    _hoursspent = response['hours_spent'];
    _profilepicture = response['profile_picture'];
    _grammarLevel = response['grammar_level'];
    _vocabularyLevel = response['vocabulary_level'];
    _listeningLevel = response['listening_level'];
    _speakingLevel = response['speaking_level'];

    // weeklyProgress = response['weekly']

    notifyListeners();
  }

  String? get languageName => _language;
  String get profilePicture => _profilepicture ?? '';
  String get username => _username ?? 'Guest';
  int get totalTime => _hoursspent;
  int get totalStars => _stars;
  String get email => _email ?? 'noone@email.com';
  String? get userId => _id;
  int get grammarLevel => _grammarLevel;
  int get vocabualryLevel => _vocabularyLevel;
  int get listeningLevel => _listeningLevel;
  int get speakingLesson => _speakingLevel;

  Future<void> updateGrammarLevel(int level) async {
    await supabase
        .from('users')
        .update({'grammar_level': level})
        .eq('id', _id!);
  }

  Future<void> updateLanguage(String language) async {
    await supabase
        .from('users')
        .update({'learning_language': language})
        .eq('id', _id!);
    language = language;

    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    await supabase.auth.signOut();

    // Clear local user state
    _id = null;
    _email = null;
    _username = null;
    _language = null;
    _stars = 0;
    _hoursspent = 0;

    notifyListeners();

    // Navigate to login screen (optional, or you can do it in UI)
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }
}
