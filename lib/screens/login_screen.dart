// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rspct/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rspct/screens/forgot_pw_screen.dart';
import 'package:rspct/buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.showRegisterScreen}) : super(key: key);
  final VoidCallback showRegisterScreen;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.deepOrangeAccent,
          ),
        );
      }
    );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim()
    );

    // pop the loading circle
    Navigator.of(context).pop();
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

              SizedBox(
                height: 25.0,
              ),

              // hello again
              Text('Hello!', style: GoogleFonts.bebasNeue(fontSize: 54)),
              SizedBox(
                height: 10,
              ),
              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 50),

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


              Padding(
                padding: const EdgeInsets.all(16.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPasswordScreen();
                            },
                          ),
                        );
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
              
              // sign in button
              // GestureDetector(
              //   onTap: signIn,
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(horizontal: 25.0),
              //     padding: EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 255, 87, 34),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Sign In',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // SizedBox(
              //   height: 10,
              // ),

              // Container(
              //   width: 1000,
              //   height: 50,
              //   margin: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child: ElevatedButton(
              //     onPressed: signIn,
              //     style: buttonPrimary,
              //     child: Text(
              //       'Sign In',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18,
              //       ),
              //     ),
              //   ),
              // ),
              
              RspctButtonStateless(text: 'Sign In', func: signIn),
              
              SizedBox(
                height: 25,
              ),

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
                    onTap: widget.showRegisterScreen,
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
