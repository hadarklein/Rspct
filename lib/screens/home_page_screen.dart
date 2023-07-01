// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rspct/animations/circle_animator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:rspct/screens/leaderboard_screen.dart';
import 'package:rspct/utils/rspct_icons.dart';
import 'package:rspct/screens/give_rspct_screen.dart';
import 'package:rspct/screens/connect_with_friend_screen.dart';
import 'package:rspct/screens/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const id = 'homepage_screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final User _user = FirebaseAuth.instance.currentUser!;
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('user_data').snapshots();
  Future<String>? _displayname;
  
  int _currentScore = 0;

  // loadDisplayName() async {
  //   var displayName = await _getDisplayName();
  //   setState(() {
  //     _displayname = displayName;
  //   });
  // }

  void fakeComputation() {
    return;
  }

  Future<String> getDisplayName() async {
    await Future.delayed(const Duration(seconds: 1), fakeComputation);
    String userName = '';

    await FirebaseFirestore.instance
      .collection('user_data')
      .doc(_user.displayName)
      .get().then(
        (snapshot) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          userName = '${data['first_name']} ${data['last_name']}';
        }
      );
    return userName;
  }

  @override
  void initState() {
    super.initState();
    // loadDisplayName();
    _displayname = getDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _displayname,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 232, 232, 232),
            appBar: AppBar(
              title: const Text('Home'),
              backgroundColor: Colors.deepOrange,
            ),
            body: SafeArea(
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
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 232, 232, 232),
              appBar: AppBar(
                title: const Text('Home'),
                backgroundColor: Colors.deepOrange,
              ),
              body: const Text('Connection Error!')
            );
          } else if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 232, 232, 232),
              appBar: AppBar(
                title: const Text('Home'),
                backgroundColor: Colors.deepOrange,
              ),
              body: const Text('No Data!')
            );
          } else {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 232, 232, 232),
              appBar: AppBar(
                title: const Text('Home'),
                backgroundColor: Colors.deepOrange,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 50,),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Image.asset('images/rspct_logo.png'),
                    ),

                    const SizedBox(height: 75,),

                    Text(
                      'Your Current Score:',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    const SizedBox(height: 10,),

                    CircleAnimatorWidget(
                      innerColor: Colors.orangeAccent,
                      outerColor: Colors.orange,
                      size: 350,
                      innerAnimationSeconds: 25,
                      outerAnimationSeconds: 12,
                      child: CircleAnimatorWidget(
                        innerColor: Colors.red,
                        outerColor: Colors.redAccent,
                        size: 250,
                        innerAnimationSeconds: 100,
                        outerAnimationSeconds: 50,
                        innerSizeMultiplier: 0.78,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _userStream,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error!');
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Loading...');
                              } else {
                                snapshot.data!.docs.map((DocumentSnapshot doc) {
                                  if (doc.id == _user.displayName) {
                                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                    _currentScore = data['points'];
                                  }
                                }).toList();
                              }
                              
                              return Text(
                                _currentScore.toString(),
                                style: const TextStyle(
                                  fontSize: 65,
                                  fontWeight: FontWeight.bold
                                ),
                              );
                            } ,
                          ),
                        )
                      ),
                    ),
                  ]
                ),
              ),
              drawer:  Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            radius: 40,
                            child: Text('${snapshot.data![0]}${snapshot.data![snapshot.data!.indexOf(' ') + 1]}'),
                          ),
                          Text(
                            snapshot.data!,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      )
                    ),
                    ListTile(
                      leading: const Icon(RspctIcons.crownEmpty, size: 40,),
                      title: const Text(
                        'Give Some Rspct!',
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, GiveRspctScreen.id);
                      }
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.leaderboard_outlined),
                    //   title: const Text(
                    //     'Leaderboard',
                    //     style: TextStyle(
                    //       fontSize: 17.5,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.pushNamed(context, LeaderboardScreen.id);
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(Icons.people_outline, size: 40,),
                      title: const Text(
                        'Find Friends',
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ConnectWithFriendScreen.id);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout_outlined,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.popAndPushNamed(context, LoginScreen.id);
                      },
                    )
                  ],
                ),
              ),
            );
          }
        }
      }
    );
  }
}
