import 'package:flutter/material.dart';


class ConnectWithFriendScreen extends StatefulWidget {
  const ConnectWithFriendScreen({Key? key}) : super(key: key);

  @override
  State<ConnectWithFriendScreen> createState() => _ConnectWithFriendState();
}

class _ConnectWithFriendState extends State<ConnectWithFriendScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect with a Friend'),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}