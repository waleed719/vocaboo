import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vocaboo/screens/account_process/login_screen.dart';

class UserProvider with ChangeNotifier {
  String? _id;
  String? _username;
  String? _email;
  String? _language;
  int _stars = 0;
  double _hoursspent = 0;
  String? _profilepicture;
  int _weeklyProgress = 0;
  int _overallProgress = 0;

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

    if (response != null) {
      _id = user.id;
      _email = user.email;
      _username = response['username'];
      _language = response['learning_language'];
      _stars = response['stars'];
      _hoursspent = response['hours_spent'];
      _profilepicture = response['profile_picture'];

      // weeklyProgress = response['weekly']

      notifyListeners();
    }
  }

  String? get languageName => _language;
  String get profilePicture => _profilepicture ?? '';
  String get username => _username ?? 'Guest';
  double get totalTime => _hoursspent;
  int get totalStars => _stars;
  String get email => _email ?? 'noone@email.com';
  String? get userId => _id;

  Future<void> updateLanguage(String language) async {
    final supabase = Supabase.instance.client;
    await supabase
        .from('users')
        .update({'learning_language': language})
        .eq('id', _id!);
    language = language;

    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    final supabase = Supabase.instance.client;

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
