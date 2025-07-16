import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocaboo/provider/language_provider.dart';
import 'package:vocaboo/routes/routes.dart';
import 'package:vocaboo/screens/account_process/confirmation_screen.dart';
import 'package:vocaboo/screens/account_process/language_selection_screen.dart';
import 'package:vocaboo/screens/delete_account_screen.dart';
import 'package:vocaboo/screens/faqs.dart';
import 'package:vocaboo/screens/home_screen.dart';
import 'package:vocaboo/screens/account_process/login_screen.dart';
import 'package:vocaboo/screens/language_progress_screen.dart';
import 'package:vocaboo/screens/onboarding_screen.dart';
import 'package:vocaboo/screens/personal_info_screen.dart';
import 'package:vocaboo/screens/setting_screen.dart';
import 'package:vocaboo/screens/account_process/signup_screen.dart';
import 'package:vocaboo/screens/support_center_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LanguageProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocaboo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.settings: (context) => const SettingScreen(),
        AppRoutes.confirmation: (context) => const ConfirmationScreen(),
        AppRoutes.languageSelection:
            (context) => const LanguageSelectionScreen(),
        AppRoutes.languageProgressScreen:
            (context) => const LanguageProgressScreen(),
        AppRoutes.faqs: (context) => const FAQScreen(),
        AppRoutes.personaInfo: (context) => const PersonalInfoScreen(),
        AppRoutes.deleteAccount: (context) => const DeleteAccountScreen(),
        AppRoutes.supportCenter: (context) => const SupportCenterScreen(),
      },
      // home: const OnboardingScreen(),
    );
  }
}
