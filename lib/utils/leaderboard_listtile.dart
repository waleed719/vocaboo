import 'package:flutter/material.dart';

class LeaderboardListTile extends StatelessWidget {
  final String name;
  final String lan;
  final int stars;
  final String imgUrl;
  final int rank;
  const LeaderboardListTile({
    super.key,
    required this.name,
    required this.lan,
    required this.stars,
    required this.imgUrl,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(lan),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 18,
      ),
      leading: Stack(
        children: [
          // CircleAvatar with yellow border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.yellow,
                width: 3.0, // Adjust border thickness as needed
              ),
            ),
            child: CircleAvatar(
              radius: 30.0, // Adjust the radius as needed
              backgroundImage: NetworkImage(imgUrl),
              backgroundColor: Colors.grey[200], // Placeholder background
            ),
          ),
          // Rank text positioned at the top-left
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: Colors.yellow, // Background color for the rank
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 24, // Adjust size of the rank circle
                minHeight: 24,
              ),
              child: Center(
                child: Text(
                  rank.toString(),
                  style: const TextStyle(
                    color: Colors.black, // Color of the rank text
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0, // Adjust font size as needed
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      trailing: Container(
        height: 20,
        width: 80,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 242, 128),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            '$stars Stars',
            style: TextStyle(color: Colors.deepOrange),
          ),
        ),
      ),
    );
  }
}
