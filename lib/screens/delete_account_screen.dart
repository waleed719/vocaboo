import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  void _confirmAndDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: const Text(
            'Are you absolutely sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss dialog
                _performAccountDeletion(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Red button for destructive action
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  void _performAccountDeletion(BuildContext context) {
    // In a real app, this would involve:
    // 1. Calling your backend API to initiate deletion.
    // 2. Handling success/failure (e.g., showing a SnackBar or AlertDialog).
    // 3. Logging out the user and navigating to the login/onboarding screen.

    print('Attempting to delete account...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleting account... (This is a mock action)'),
      ),
    );

    // Simulate a delay for backend operation
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully!')),
      );
      // Navigate to login screen and clear navigation stack
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your LoginScreen
      //   (Route<dynamic> route) => false,
      // );
      Navigator.of(context).pop(); // For now, just pop back
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              'Permanent Account Deletion',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Deleting your account is a permanent action. All your data, including progress, settings, and personal information, will be irrecoverably lost.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Text(
              'To proceed with account deletion, please understand and agree to the following:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildWarningPoint('You will lose all your learning progress.'),
            _buildWarningPoint('Your user history and data will be removed.'),
            _buildWarningPoint('This action cannot be undone.'),
            const Spacer(), // Pushes the button to the bottom
            ElevatedButton(
              onPressed: () => _confirmAndDeleteAccount(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Destructive action color
                foregroundColor: Colors.white,
                minimumSize: const Size(
                  double.infinity,
                  55,
                ), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Delete My Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
