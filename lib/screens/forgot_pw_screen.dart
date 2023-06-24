// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rspct/constants.dart';
import 'package:rspct/buttons.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState(); 
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim()
      );
      passwordResetDialog('Reset Request Sent', 'Check your email for a reset link');
    } on FirebaseAuthException catch (e) {
      passwordResetDialog('Authentication Error!', e.message.toString());
    }
  }

  Future<dynamic> passwordResetDialog(String title, String content) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            MaterialButton(
              color: Colors.deepOrange,
              onPressed: ok,
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        );
      }
    );
  }

  void ok() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 214, 214),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Image.asset(
              'images/rspct_logo.png',
            ),
          ),
          const SizedBox(
            height: 200.0,
          ),
          const Text(
            'Enter your email to reset your password',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10,),
          LoginTextField(
            controller: _emailController,
            hintText: 'Email',
          ),
          const SizedBox(height: 10,),
          Container(
            width: 1000,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ElevatedButton(
              onPressed: resetPassword,
              style: buttonPrimary,
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 100,)
        ]
      ),
    );
  }
}
