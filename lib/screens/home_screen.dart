import 'package:flutter/material.dart';
import 'package:vocaboo/screens/language_progress_screen.dart';
import 'package:vocaboo/screens/leader_board_screen.dart';
import 'package:vocaboo/screens/profile_screen.dart';
import 'package:vocaboo/screens/progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _screens = [
    const LanguageProgressScreen(),
    const LeaderBoardScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];
  void _ontappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () => Navigator.pushNamed(context, '/settings'),
      //       icon: Icon(Icons.settings),
      //     ),
      //   ],
      // ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'LeaderBoard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.score), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _ontappedItem,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
