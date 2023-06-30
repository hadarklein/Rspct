// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rspct/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rspct/screens/forgot_pw_screen.dart';
import 'package:rspct/buttons.dart';
import 'package:rspct/screens/home_page_screen.dart';
import 'package:rspct/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, /*required this.showRegisterScreen*/}) : super(key: key);
  // final VoidCallback showRegisterScreen;

  static const id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(
    //       child: CircularProgressIndicator(
    //         color: Colors.deepOrangeAccent,
    //       ),
    //     );
    //   }
    // );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim()
    );

    // pop the loading circle
    // Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        Navigator.pushNamed(context, HomePage.id);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Color.fromARGB(255, 214, 214, 214),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // icon
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0),
                child: Image.asset(
                  'images/rspct_logo.png',
                ),
              ),

              SizedBox(height: 25.0,),

              // hello again
              Text('Hello!', style: GoogleFonts.bebasNeue(fontSize: 54)),
              
              SizedBox(height: 10,),

              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 50),

              // email textfield
              LoginTextField(controller: _emailController, hintText: 'Email'),

              SizedBox(height: 10,),

              // password textfield
              LoginTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.5, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ForgotPasswordScreen.id);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              
              RspctButtonStateless(text: 'Sign In', func: signIn),
              
              SizedBox(height: 25,),

              // register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    // onTap: widget.showRegisterScreen,
                    onTap: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    child: Text(
                      'Register Now!',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
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
