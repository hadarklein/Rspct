// import 'package:flutter/material.dart';
// import 'package:rspct/screens/login_screen.dart';
// import 'package:rspct/screens/registration_screen.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({Key? key}) : super(key: key);

//   static const id = 'auth_page_screen';

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   // initially show the login page
//   bool showLoginPage = true;

//   void toggleScreens() {
//     setState(() {
//       showLoginPage = !showLoginPage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showLoginPage) {
//       return LoginScreen(/*showRegisterScreen: toggleScreens*/);
//     } else {
//       return RegistrationScreen(/*showLoginScreen: toggleScreens*/);
//     }
//   }
// }