import 'package:flutter/material.dart';


TextStyle hiddenDrawerFontStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontSize: 16.5,
  shadows: [
    Shadow( // bottomLeft
      offset: Offset(-0.5, -0.5),
      color: Colors.black
    ),
    Shadow( // bottomRight
      offset: Offset(0.5, -0.5),
      color: Colors.black
    ),
    Shadow( // topRight
      offset: Offset(0.5, 0.5),
      color: Colors.black
    ),
    Shadow( // topLeft
      offset: Offset(-0.5, 0.5),
      color: Colors.black
    ),
  ]
);

class LoginTextField extends StatelessWidget {
  const LoginTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.obscureText = false})
      : super(key: key);

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }
}

String flattenPhone(String phone) {
  return phone.replaceAll('-', '').replaceAll('(', '').replaceAll(')', '');
}





