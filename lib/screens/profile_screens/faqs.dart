import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  // A list to hold your FAQ data
  final List<Map<String, String>> faqItems = [
    {
      'question': 'How is the learning method in this app?',
      'answer':
          'Our app utilizes a gamified, interactive learning approach combined with spaced repetition and personalized feedback. This ensures engaging and effective learning sessions, tailored to your individual progress.',
    },
    {
      'question': 'Is this app suitable for beginners?',
      'answer':
          'Absolutely! Our app is designed to cater to learners of all levels, from complete beginners to advanced students. We offer structured lessons that gradually increase in difficulty, along with foundational exercises.',
    },
    {
      'question': 'Does it support languages other than English?',
      'answer':
          'Yes, we support multiple languages such as English, Spanish, Palestinian, German, Japanese, Korean and more. You can easily switch your learning language in the app settings.',
    },
    {
      'question': 'Can it be accessed offline?',
      'answer':
          'Certain features and downloaded content can be accessed offline. Once lessons or resources are downloaded, you can continue your learning journey even without an internet connection.',
    },
    {
      'question': 'Is this app safe to use?',
      'answer':
          'Yes, your safety and privacy are our top priorities. We employ robust security measures to protect your data and ensure a secure learning environment. Please refer to our Privacy Policy for more details.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
          'You can contact our customer support team directly through the "Contact Us" section within the app, or by sending an email to support@yourapp.com. We typically respond within 24-48 hours.',
    },
  ];

  // Optional: A set to keep track of which tiles are expanded, if you need to control them.
  // For basic ExpansionTile, you don't need this, as they manage their own state.
  // Set<int> _expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The back arrow icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        title: const Text('FAQ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true, // Center the title as seen in the image
        elevation: 0, // Remove shadow under the app bar
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          final faq = faqItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 6.0,
            ), // Adjust margin for spacing between cards
            elevation: 0, // No card shadow as in the image
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ), // Slight rounded corners for cards
              side: BorderSide(
                color: Colors.grey.shade200,
                width: 1.0,
              ), // Light border for separation
            ),
            child: Theme(
              // Override default expansion tile theme for less padding and different arrow
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ), // Adjust tile padding
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium weight for questions
                    color: Colors.black87,
                  ),
                ),
                // Custom trailing icon for the expand/collapse arrow
                trailing: const Icon(
                  Icons.keyboard_arrow_down,
                ), // Down arrow for collapsed state
                // This builds the answer when the tile is expanded
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    child: Align(
                      alignment:
                          Alignment.centerLeft, // Align answer text to the left
                      child: Text(
                        faq['answer']!,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Colors
                                  .grey[700], // Slightly darker grey for readability
                        ),
                      ),
                    ),
                  ),
                ],
                // Callback when the tile is expanded or collapsed
                onExpansionChanged: (isExpanded) {
                  // If you wanted to track expanded state globally:
                  // setState(() {
                  //   if (isExpanded) {
                  //     _expandedIndexes.add(index);
                  //   } else {
                  //     _expandedIndexes.remove(index);
                  //   }
                  // });
                },
                // Initial expanded state (optional, for "Does it support languages..." example)
                // If you want a specific tile to be expanded by default:
                // initiallyExpanded: index == 2, // Expands the third item (index 2) by default
              ),
            ),
          );
        },
      ),
    );
  }
}
