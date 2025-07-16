import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;
  final pages = [
    onboardPage(
      "assets/onboardingImages/image1.png",
      "Learn Anytime, Anywhere",
      "Vocaboo will accompany you to learn languages whenever and wherever you are.",
    ),
    onboardPage(
      "assets/onboardingImages/image2.png",
      "PInteractive and Fun Learning",
      "With engaging and interactive learning, you can improve your language skills effectively.",
    ),
    onboardPage(
      "assets/onboardingImages/image3.png",
      "Get Started Now!",
      "Let's start now to upgrade your language skills and track your progress with Vocaboo.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.pushReplacementNamed(context, '/login'),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == pages.length - 1;
                  });
                },
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: controller,
                    count: pages.length,
                    effect: WormEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed:
                        isLastPage
                            ? () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            )
                            : () => controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            ),
                    child: Text(isLastPage ? "Get Started" : "Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget onboardPage(String img, String title, String subtitle) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(img),
      const SizedBox(height: 20),
      Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}
