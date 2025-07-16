import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/success.json',
                  repeat: false,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Account Created Successfully!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Now please select the language you want to learn.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('Let\'s Go'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
