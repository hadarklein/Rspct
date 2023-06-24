// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = FirebaseAuth.instance.currentUser!;
  String _displayname = '';
  String idToken = '';
  
  loadDisplayName() async {
    var displayName = await _getDisplayName();
    setState(() {
      _displayname = displayName;
    });
  }

  Future<String> _getDisplayName() async {
    user = FirebaseAuth.instance.currentUser!;
    if (user.displayName == null) {
      return '';
    } else {
      return user.displayName!;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.displayName == null) {
            loadDisplayName();
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingBouncingGrid.circle(
                      borderColor: Colors.deepPurpleAccent,
                      backgroundColor: Colors.deepOrange,
                      size: 120.0,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50,),
                    // logo
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Image.asset(
                        'images/rspct_logo.png',
                      ),
                    ),

                    // SizedBox
                    const SizedBox(height: 25,),

                    // my score


                    // SizedBox
                    const SizedBox(height: 25,),

                    
                  ],
                ),
              ),
            );
          }
        }
      )
    );
  }  
}



























////////////////////////////////////////////////////////////////////////////////


// this was inside the Column

// // Give Rspct button
// RspctButtonStateless(text: 'Give Rspct!', func: (){
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) {
//         return GiveRspctScreen(/*user: user,*/);
//       },
//     ),
//   );
// }),

// // SizedBox
// const SizedBox(height: 10,),

// // Leaderboard
// RspctButtonStateless(text: 'Leaderboard', func:() {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) {
//         return LeaderboardScreen();
//       }
//     )
//   );
// }),


// // SizedBox
// const SizedBox(height: 10,),

// // Connect with a friend
// RspctButtonStateless(text: 'Connect With a Friend', func: () {
//   Navigator.push(
//     context, 
//     MaterialPageRoute(
//       builder: (context) {
//         return ConnectWithFriendScreen();
//       }
//     )
//   );
// }),

// Expanded(
//   child: Text('Hello There!')
// )






////////////////////////////////////////////////////////////////////////////////



// this was after the scaffold???

// if (_displayname == ''){
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('null'),
    //       backgroundColor: Colors.deepOrange,
    //     ),
    //     body: SafeArea(
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             LoadingBouncingGrid.square(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     appBar: AppBar(
    //       leading: GestureDetector(
    //         child: const Icon(Icons.logout_sharp),
    //         onTap: () {
    //           FirebaseAuth.instance.signOut();
    //         },
    //       ),
    //       title: Text(_displayname),
    //       // title: Text(user.email!),
    //       backgroundColor: Colors.deepOrange,
    //     ),
    //     body: SafeArea(
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             const SizedBox(height: 50,),
    //             // logo
    //             Container(
    //               margin: EdgeInsets.symmetric(horizontal: 50.0),
    //               child: Image.asset(
    //                 'images/rspct_logo.png',
    //               ),
    //             ),

    //             // SizedBox
    //             const SizedBox(height: 25,),

    //             // my score


    //             // SizedBox
    //             const SizedBox(height: 25,),

    //             // Give Rspct button
    //             RspctButtonStateless(text: 'Give Rspct!', func: (){
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return GiveRspctScreen();
    //                   },
    //                 ),
    //               );
    //             }),

    //             // SizedBox
    //             const SizedBox(height: 10,),

    //             // Leaderboard
    //             RspctButtonStateless(text: 'Leaderboard', func:() {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return LeaderboardScreen();
    //                   }
    //                 )
    //               );
    //             }),


    //             // SizedBox
    //             const SizedBox(height: 10,),

    //             // Connect with a friend
    //             RspctButtonStateless(text: 'Connect With a Friend', func: () {
    //               Navigator.push(
    //                 context, 
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return ConnectWithFriendScreen();
    //                   }
    //                 )
    //               );
    //             }),

    //             // Expanded(
    //             //   child: Text('Hello There!')
    //             // )
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }