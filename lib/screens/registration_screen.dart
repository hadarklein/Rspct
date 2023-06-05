// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rspct/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rspct/buttons.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, required this.showLoginScreen}) : super(key: key);
  final VoidCallback showLoginScreen;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _displaynameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  
  Future register() async {
    if (passwordConfirmed()) {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
      User? user = result.user;
      user?.updateDisplayName(_displaynameController.text.trim());

      addUserData(
        _displaynameController.text.trim(),
        _firstnameController.text.trim(),
        _lastnameController.text.trim(),
        _emailController.text.trim()
      );
    } else {
      await openPasswordErrorDialog();
    }
  }

  Future addUserData(String displayname, String firstname, String lastname, String email) async {
    await FirebaseFirestore.instance.collection('user_data').add({
      'displayname' : displayname,
      'first_name' : firstname,
      'last_name' : lastname,
      'email' : email,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() == 
      _passwordConfirmController.text.trim()) {
      return true;
    }
    return false;
  }

  Future openPasswordErrorDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Password Error!'),
      content: Text('There was a mismatch between the typed passwords'),
      actions: [
        TextButton(
          child: Text('Ok'),
          onPressed: ok,
        )
      ],
    ),
  );

  void ok() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _displaynameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 214, 214),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // icon

              Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0),
                child: Image.asset(
                  'images/rspct_logo.png',
                ),
              ),

              SizedBox(
                height: 25.0,
              ),

              // hello again
              Text('Hello There!', style: GoogleFonts.bebasNeue(fontSize: 54)),
              SizedBox(
                height: 10,
              ),
              Text(
                'Welcome. Please Register.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 50),

              // first name textfield
              LoginTextField(controller: _firstnameController, hintText: 'First Name'),

              SizedBox(
                height: 10,
              ),

              // last name textfield
              LoginTextField(controller: _lastnameController, hintText: 'Last Name'),

              SizedBox(
                height: 10,
              ),

              // display name textfield
              LoginTextField(controller: _displaynameController, hintText: 'Display Name'),

              SizedBox(
                height: 10,
              ),

  
              // email textfield
              LoginTextField(controller: _emailController, hintText: 'Email'),

              SizedBox(
                height: 10,
              ),

              // password textfield
              LoginTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              SizedBox(
                height: 10,
              ),

              // password confirm textfield
              LoginTextField(
                controller: _passwordConfirmController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                width: 1000,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  onPressed: register,
                  style: buttonPrimary,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              
                SizedBox(
                height: 25,
              ),

              // register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showLoginScreen,
                    child: Text(
                      'Sign In Now!',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}


