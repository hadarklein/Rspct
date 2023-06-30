// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:rspct/hidden_drawer.dart';
// import 'package:rspct/screens/home_page_screen.dart';
// import 'package:rspct/auth/auth_page.dart';


// class AuthStatusChecker extends StatefulWidget {
//   const AuthStatusChecker({ Key? key }) : super(key: key);

//   static const id = 'auth_status_checker_screen';

//   @override
//   State<AuthStatusChecker> createState() => _AuthStatusCheckerState();
// }

// class _AuthStatusCheckerState extends State<AuthStatusChecker> {
  
  

//   @override
//   void initState() {
//     super.initState();

//     FirebaseAuth.instance.authStateChanges().listen((event) {
//       if (event != null) {
//         Navigator.pushNamed(context, AuthPage.id);
//       } else {
//         Navigator.pushNamed(context, HomePage.id);
//       }
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }

// // class AuthStatusChecker extends StatelessWidget {
// //   const AuthStatusChecker({Key? key}) : super(key: key);

// //   static const id = 'auth_status_checker_screen';

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: StreamBuilder<User?>(
// //         stream: FirebaseAuth.instance.authStateChanges(),
// //         builder: (context, snapshot) {
// //           if (snapshot.hasData) {
// //             Navigator.pushNamed(
// //               context,
// //               HomePage.id
// //             );
// //             // return HomePage();
// //             // return HiddenDrawer();
// //           } else {
// //             // return AuthPage();
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
