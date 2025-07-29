import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vocaboo/widgets/customtextfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> handleSignUpWithVerification({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      // Sign up user
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      if (userId == null) {
        // Handle sign up failure
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to create account')));
        }
        return;
      }

      // Insert user data
      await supabase.from('users').insert({
        'id': userId,
        'email': email,
        'username': name,
        'learning_language': 'English',
        'stars': 0,
        'hours_spent': 0,
        'profile_picture': null,
      });

      // Show verification dialog
      if (context.mounted) {
        _showVerificationDialog(context, email);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showVerificationDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false, // User can't dismiss by tapping outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Verify Your Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.email_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 16),
              Text(
                'We\'ve sent a verification email to:',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Please check your email and click the verification link to continue.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                // Navigate to next screen
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('I\'ve Verified'),
            ),
            TextButton(
              onPressed: () async {
                // Resend verification email
                try {
                  await Supabase.instance.client.auth.resend(
                    type: OtpType.signup,
                    email: email,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Verification email sent again')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to resend email')),
                  );
                }
              },
              child: Text('Resend Email'),
            ),
          ],
        );
      },
    );
  }

  // Alternative: Auto-detect verification using auth state listener
  StreamSubscription<AuthState>? _authSubscription;

  void _startListeningForVerification(BuildContext context) {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final user = data.session?.user;
      if (user != null && user.emailConfirmedAt != null) {
        // Email verified! Navigate to next screen
        if (context.mounted) {
          Navigator.of(context).pop(); // Close dialog
          Navigator.pushReplacementNamed(context, '/languageSelection');
        }
      }
    });
  }

  void _stopListeningForVerification() {
    _authSubscription?.cancel();
  }

  // Enhanced version with auto-detection
  Future<void> handleSignUpWithAutoVerification({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      // Sign up user
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      if (userId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to create account')));
        }
        return;
      }

      // Insert user data
      await supabase.from('users').insert({
        'id': userId,
        'email': email,
        'username': name,
        'learning_language': 'English',
        'stars': 0,
        'hours_spent': 0,
        'profile_picture': null,
      });

      // Start listening for verification
      _startListeningForVerification(context);

      // Show verification dialog with auto-detection
      if (context.mounted) {
        _showAutoVerificationDialog(context, email);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showAutoVerificationDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Verify Your Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Waiting for email verification...',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'We\'ve sent a verification email to $email',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Click the link in your email to continue.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _stopListeningForVerification();
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.resend(
                    type: OtpType.signup,
                    email: email,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Verification email sent again')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to resend email')),
                  );
                }
              },
              child: Text('Resend'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final userId = response.user?.id;
      if (userId == null) return "Failed to SignIn";
      await supabase.from('users').insert({
        'id': userId,
        'email': email,
        'username': name,
        'learning_language': 'English', // default or dynamic
        'stars': 0,
        'hours_spent': 0,
        'profile_picture': null,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Important for keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Create new Account',
                      style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Let\'s Learn Together',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/login/signup.png',
                      height: 200, // fixed height instead of Flexible
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: nameController,
                            label: 'Username',
                            keyboardtype: TextInputType.text,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: 'Email',
                            controller: emailController,
                            keyboardtype: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: 'Password',
                            controller: passwordController,
                            keyboardtype: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: " Login",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap =
                                      () => Navigator.pushReplacementNamed(
                                        context,
                                        '/login',
                                      ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await handleSignUpWithAutoVerification(
                          context: context,
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const Spacer(), // pushes the button to the bottom if there's space
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
