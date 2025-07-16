import 'package:flutter/material.dart';
import 'package:vocaboo/utils/leaderboard_listtile.dart';

class RankedProfileCard extends StatelessWidget {
  final LeaderboardListTile tile;
  final double cardHeight;
  final Color cardColor;

  const RankedProfileCard({
    super.key,

    this.cardHeight = 150.0,
    this.cardColor = Colors.deepPurple,
    required this.tile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110, // Enforce consistent width for the entire card
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center children horizontally
        children: [
          // RankAvatar positioned above the main card
          Stack(
            alignment: Alignment.center, // Center the avatar
            children: [
              // CircleAvatar with yellow border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.yellow, width: 3.0),
                ),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(tile.imgUrl),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              // Rank text positioned at the top-left
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  child: Center(
                    child: Text(
                      tile.rank.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // The main rectangular card
          Container(
            height: cardHeight,
            width: 110, // Fixed width
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // User's name at the top-center, with wrapping
                Positioned(
                  top: 15,
                  left: 8, // Add padding to prevent text from touching edges
                  right: 8,
                  child: Center(
                    child: Text(
                      tile.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2, // Allow up to 2 lines for wrapping
                      overflow:
                          TextOverflow.ellipsis, // Ellipsis if still too long
                    ),
                  ),
                ),
                // User's stars at the bottom-center
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${tile.stars} Stars',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
