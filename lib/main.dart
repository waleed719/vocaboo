import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vocaboo/provider/language_provider.dart';
import 'package:vocaboo/provider/user_provider.dart';
import 'package:vocaboo/routes/routes.dart';
import 'package:vocaboo/screens/account_process/confirmation_screen.dart';
import 'package:vocaboo/screens/account_process/language_selection_screen.dart';
import 'package:vocaboo/screens/leader_board_screen.dart';
import 'package:vocaboo/screens/profile_screens/delete_account_screen.dart';
import 'package:vocaboo/screens/profile_screens/faqs.dart';
import 'package:vocaboo/screens/home_screen.dart';
import 'package:vocaboo/screens/account_process/login_screen.dart';
import 'package:vocaboo/screens/language_progress_screen.dart';
import 'package:vocaboo/screens/onboarding_screen.dart';
import 'package:vocaboo/screens/profile_screens/personal_info_screen.dart';
import 'package:vocaboo/screens/profile_screens/setting_screen.dart';
import 'package:vocaboo/screens/account_process/signup_screen.dart';
import 'package:vocaboo/screens/profile_screens/support_center_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  const supabaseUrl = 'https://vcbegogbwwodiswschtc.supabase.co';
  final supabaseKey = dotenv.env['SUPABASE_KEY'] ?? 'No Key';
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
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
      initialRoute: AppRoutes.onboarding,
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
        AppRoutes.leaderboard: (context) => const LeaderBoardScreen(),
      },
      // home: const OnboardingScreen(),
    );
  }
}
