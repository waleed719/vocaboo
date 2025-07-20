import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this to your pubspec.yaml

class SupportCenterScreen extends StatefulWidget {
  const SupportCenterScreen({super.key});

  @override
  State<SupportCenterScreen> createState() => _SupportCenterScreenState();
}

class _SupportCenterScreenState extends State<SupportCenterScreen> {
  // Function to launch email client
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@yourapp.com',
      queryParameters: {
        'subject': 'Support Request from App User',
        'body': 'Hello Support Team,\n\n',
      },
    );
    if (!await launchUrl(emailLaunchUri)) {
      if (context.mounted) {
        // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email client.')),
        );
      }
    }
  }

  // Function to launch phone dialer
  Future<void> _launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: '+1234567890', // Replace with your support phone number
    );
    if (!await launchUrl(phoneLaunchUri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer.')),
        );
      }
    }
  }

  // Function to launch a web URL (e.g., for live chat or help articles)
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
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
          'Support Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Choose one of the options below to get in touch with our support team or find answers to common questions.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            // Option: Email Support
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.email_outlined, color: Colors.blue),
                title: const Text(
                  'Email Support',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Send us an email and we\'ll respond within 24-48 hours.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _launchEmail,
              ),
            ),
            const SizedBox(height: 10),

            // Option: Call Support (if applicable)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone_outlined, color: Colors.green),
                title: const Text(
                  'Call Support',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Speak directly with a support agent. Available M-F, 9AM-5PM.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _launchPhone,
              ),
            ),
            const SizedBox(height: 10),

            // Option: Live Chat (if you have one)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.chat_outlined, color: Colors.purple),
                title: const Text(
                  'Live Chat',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Chat with us in real-time for immediate assistance.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap:
                    () => _launchUrl(
                      'https://your-live-chat-url.com',
                    ), // Replace with actual live chat URL
              ),
            ),
            const SizedBox(height: 10),

            // Option: Help Center / Knowledge Base
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.article_outlined,
                  color: Colors.orange,
                ),
                title: const Text(
                  'Help Articles',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Browse our comprehensive articles for self-help.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap:
                    () => _launchUrl(
                      'https://your-help-center-url.com',
                    ), // Replace with your help center URL
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: Text(
                'You can also reach us on social media!',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.facebook,
                    size: 36,
                    color: Colors.blue.shade700,
                  ),
                  onPressed: () => _launchUrl('https://facebook.com/your-app'),
                  tooltip: 'Facebook',
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    Icons.alternate_email,
                    size: 36,
                    color: Colors.pink.shade700,
                  ), // Instagram-like icon
                  onPressed: () => _launchUrl('https://instagram.com/your-app'),
                  tooltip: 'Instagram',
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    Icons.wechat,
                    size: 36,
                    color: Colors.lightBlue,
                  ), // Twitter-like icon, or use a custom SVG if needed
                  onPressed: () => _launchUrl('https://twitter.com/your-app'),
                  tooltip: 'Twitter',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
