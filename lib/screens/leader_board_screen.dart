import 'package:flutter/material.dart';
import 'package:vocaboo/utils/leaderboard_list.dart';
import 'package:vocaboo/utils/ranked_profile_card.dart'; // Your import for RankedProfileCard

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RankedProfileCard(
                    cardHeight: 140, // Height for 2nd place
                    tile: leaderboard[1],
                  ),
                  RankedProfileCard(
                    cardHeight: 180, // Height for 1st place
                    tile: leaderboard[0],
                  ),
                  RankedProfileCard(
                    cardHeight: 100, // Height for 3rd place
                    tile: leaderboard[2],
                  ),
                ],
              ),

              Expanded(
                child: Container(
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
                    children: [
                      Text(
                        'Top Learners of the Week',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Flexible(
                        child: ListView.builder(
                          itemCount: leaderboard.length - 3,

                          itemBuilder: (context, index) {
                            return leaderboard[index + 3];
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
