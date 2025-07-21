import 'package:flutter/material.dart';
import 'package:vocaboo/screens/speaking_screens/speaking_detial_screen.dart';

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  ScrollController scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // Check if scrolled past certain threshold
      bool scrolled = scrollController.offset > 50;
      if (scrolled != _isScrolled) {
        setState(() {
          _isScrolled = scrolled;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // int currentLevel = 2;
    int levelcompleted = 5;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Text(
                'Speaking',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Level 1',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProgressCardForScreens(
                    title: "22H",
                    subtitle: 'time spend',
                    backgroundColor: Colors.blue.shade900,
                    context: context,
                  ),
                  _buildProgressCardForScreens(
                    title: "340",
                    subtitle: 'Stars',
                    backgroundColor: Colors.blue.shade900,
                    context: context,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                  ), // No bottom padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  // color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Speaking Lessons',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                          Spacer(),
                          Text('Total Level: 20'),
                        ],
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: 20,

                          itemBuilder: (context, index) {
                            int levelNum = index + 1;
                            bool isLocked = levelNum > levelcompleted;

                            return LevelCard(
                              level: levelNum,
                              questions: 10 + levelNum,
                              stars: 2,
                              totalStars: (10 + levelNum) * 3,
                              isLocked: isLocked,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SpeakingDetailScreen(
                                          level: levelNum,
                                          theme: 'greetings',
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final int level;
  final int questions;
  final int stars;
  final int totalStars;
  // final String theme;
  final bool isLocked;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.questions,
    required this.stars,
    required this.totalStars,
    // required this.theme,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isLocked ? Colors.grey.shade200 : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isLocked ? null : onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey : Colors.blue[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isLocked
                        ? Icon(Icons.lock, color: Colors.white, size: 20)
                        : Text(
                          '$level',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   // theme,
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w600,
                    //     color: isLocked ? Colors.grey : Colors.black,
                    //   ),
                    // ),
                    // SizedBox(height: 4),
                    Text(
                      '$questions Questions',
                      style: TextStyle(
                        fontSize: 14,
                        color: isLocked ? Colors.grey : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLocked) ...[
                Column(
                  children: [
                    Row(
                      children: List.generate(3, (index) {
                        return Icon(
                          index < (stars / (totalStars / 3)).floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$stars/$totalStars',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ] else ...[
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProgressCardForScreens({
  required String title,
  required String subtitle,
  required Color backgroundColor,
  required BuildContext context,
}) {
  return SizedBox(
    width: (MediaQuery.of(context).size.width / 2) - 20,
    child: Card(
      elevation: 0, // No shadow for cards
      color: backgroundColor,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(subtitle, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}
