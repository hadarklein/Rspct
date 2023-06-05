import 'package:flutter/material.dart';


final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepOrange,
  // minimumSize: const Size(1000, 1000),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12)
    ),
  ),
);

class RspctButtonStateful extends StatefulWidget {
  RspctButtonStateful({Key? key, required this.text, required this.func}) : super(key: key);

  String text;
  final VoidCallback func;

  @override
  State<RspctButtonStateful> createState() => _RspctButtonState();
}

class _RspctButtonState extends State<RspctButtonStateful> {

  void changeName() {
    setState(() {
      widget.text = 'bob';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        onPressed: changeName,
        style: buttonPrimary,
        child: Text(
          widget.text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class RspctButtonStateless extends StatelessWidget {
  const RspctButtonStateless({Key? key, required this.text, required this.func}) : super(key: key);

  final String text;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        onPressed: func,
        style: buttonPrimary,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}