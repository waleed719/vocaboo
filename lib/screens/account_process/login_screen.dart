import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vocaboo/widgets/customtextfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
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
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Let\'s Learn Togather Again',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/login/login.png',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
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
                        text: "Dont have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: " Create one",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap =
                                      () => Navigator.pushNamed(
                                        context,
                                        '/signup',
                                      ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.pushReplacementNamed(
                            context,
                            '/languageSelection',
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text('Login', style: TextStyle(fontSize: 18)),
                    ),
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
