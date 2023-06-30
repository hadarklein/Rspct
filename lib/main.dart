import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rspct/screens/choose_friend_screen.dart';
import 'package:rspct/screens/connect_with_friend_screen.dart';
import 'package:rspct/screens/forgot_pw_screen.dart';
import 'package:rspct/screens/give_rspct_screen.dart';
import 'package:rspct/screens/home_page_screen.dart';
import 'package:rspct/screens/leaderboard_screen.dart';
import 'package:rspct/screens/login_screen.dart';
import 'package:rspct/screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: AuthStatusChecker(),

      // initialRoute: AuthStatusChecker.id,
      initialRoute: LoginScreen.id,
      routes: {
        // AuthPage.id :(context) => AuthPage(),
        // AuthStatusChecker.id : (context) => AuthStatusChecker(),
        RegistrationScreen.id : (context) => const RegistrationScreen(),
        LoginScreen.id : (context) => const LoginScreen(),
        // LogoutScreen.id :(context) => const LogoutScreen(),
        ForgotPasswordScreen.id : (context) => const ForgotPasswordScreen(),

        HomePage.id :(context) => const HomePage(),
        GiveRspctScreen.id :(context) => const GiveRspctScreen(),
        ChooseFriendScreen.id :(context) => const ChooseFriendScreen(),
        ConnectWithFriendScreen.id :(context) => const ConnectWithFriendScreen(),
        LeaderboardScreen.id :(context) => const LeaderboardScreen(),
      },
    );
  }
}
