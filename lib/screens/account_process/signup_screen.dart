import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vocaboo/widgets/customtextfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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
                      onPressed: () {
                        // Your sign-up logic here
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
