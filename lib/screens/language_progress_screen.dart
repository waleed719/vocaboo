import 'package:flutter/material.dart';
import 'package:vocaboo/utils/leaderboard_list.dart';

class LanguageProgressScreen extends StatefulWidget {
  const LanguageProgressScreen({super.key});

  @override
  State<LanguageProgressScreen> createState() => _LanguageProgressScreenState();
}

class _LanguageProgressScreenState extends State<LanguageProgressScreen> {
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
    final List<Widget> myGridItems = [
      _buildProgressCircle('Grammers', 45, 1, Colors.blue, Icons.layers),
      _buildProgressCircle(
        'Vocabulary',
        73,
        4,
        Colors.purple,
        Icons.content_paste_search_sharp,
      ),
      _buildProgressCircle(
        'Speaking',
        16,
        6,
        Colors.orange,
        Icons.mic_outlined,
      ),
      _buildProgressCircle('Listening', 25, 8, Colors.pink, Icons.volume_up),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            // App Bar Section
            SliverAppBar(
              pinned: true,
              backgroundColor:
                  _isScrolled ? Colors.blue.shade700 : Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: SafeArea(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1652715256284-6cba3e829a70?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ), // Replace with flag image
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ghazalli Syaqih',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // background: SafeArea(
                //   child:
                // ),
              ),
            ),
            // Daily Streak Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 130,
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Streak',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStreakItem('Day 1', true, context),
                            _buildStreakItem('Day 2', true, context),
                            _buildStreakItem('Day 3', true, context),
                            _buildStreakItem('Day 4', true, context),
                            _buildStreakItem('Day 5', false, context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Main Lesson Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Main Lesson',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Learn these 4 main lessons to upgrade your skills',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 350,
                          child: GridView.builder(
                            //padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: myGridItems.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.5,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              final item = myGridItems[index];
                              return item;
                            },
                          ),
                        ),

                        // Your Progress Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('More Detail'),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'December - Week 3',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Time Spend',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text('18 Hours'),
                              ],
                            ),
                            LinearProgressIndicator(
                              value: 18 / 20, // Example value
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                              minHeight: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),

                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  'Total Stars',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text('1402 Stars'),
                              ],
                            ),
                            LinearProgressIndicator(
                              value: 1402 / 1500, // Example value
                              backgroundColor: Colors.grey[300],
                              minHeight: 20,
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'Vocaboo Leaderboard',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.leaderboard),
                            ),
                          ],
                        ),
                        Text('Top 3 in this Week'),
                        leaderboard[0], leaderboard[1], leaderboard[2],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakItem(String day, bool isCompleted, BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isCompleted ? Colors.blue : Colors.grey,
          child: Icon(
            isCompleted ? Icons.check : Icons.rocket,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCircle(
    String title,
    double percentage,
    int level,
    Color color,
    IconData icondata,
  ) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.grey.shade50,
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              children: [
                Icon(icondata, color: color),
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                Text('Level $level', style: TextStyle(color: Colors.grey)),
              ],
            ),
            Spacer(),
            CircularProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              color: color,
              strokeWidth: 6,
            ),
          ],
        ),
      ),
    );
  }
}
