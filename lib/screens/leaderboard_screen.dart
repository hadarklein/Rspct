import 'package:flutter/material.dart';


class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<LeaderboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}