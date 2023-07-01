import 'package:flutter/material.dart';


class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  static const id = 'leaderboard_screen';

  @override
  State<LeaderboardScreen> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<LeaderboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
