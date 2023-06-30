// import 'package:flutter/material.dart';
// import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
// import 'package:rspct/screens/connect_with_friend_screen.dart';
// import 'package:rspct/screens/give_rspct_screen.dart';
// import 'package:rspct/screens/home_page_screen.dart';
// // import 'package:rspct/screens/leaderboard_screen.dart';
// // import 'package:rspct/screens/logout_screen.dart';

// import 'constants.dart';

// class HiddenDrawer extends StatefulWidget {
//   const HiddenDrawer({ Key? key }) : super(key: key);

//   @override
//   State<HiddenDrawer> createState() => _HiddenDrawerState();
// }

// class _HiddenDrawerState extends State<HiddenDrawer> {
//   List<ScreenHiddenDrawer> _screens = [];

//   @override
//   void initState() {
//     super.initState();

//     _screens = [
//       ScreenHiddenDrawer(
//         ItemHiddenMenu(
//           name: 'Home',
//           baseStyle: hiddenDrawerFontStyle,
//           selectedStyle: hiddenDrawerFontStyle,
//           colorLineSelected: Colors.deepPurpleAccent
//         ),
//         const HomePage()
//       ),
//       ScreenHiddenDrawer(
//         ItemHiddenMenu(
//           name: 'Give Some Rspct', 
//           baseStyle: hiddenDrawerFontStyle, 
//           selectedStyle: hiddenDrawerFontStyle,
//           colorLineSelected: Colors.deepPurpleAccent
//         ),
//         const GiveRspctScreen()
//       ),
//       // Removed for MVP, add back for subsequent versions
//       // ScreenHiddenDrawer(
//       //   ItemHiddenMenu(
//       //     name: 'Leaderboard', 
//       //     baseStyle: hiddenDrawerFontStyle, 
//       //     selectedStyle: hiddenDrawerFontStyle,
//       //     colorLineSelected: Colors.deepPurpleAccent
//       //   ),
//       //   LeaderboardScreen()
//       // ),
//       ScreenHiddenDrawer(
//         ItemHiddenMenu(
//           name: 'Find Friends', 
//           baseStyle: hiddenDrawerFontStyle, 
//           selectedStyle: hiddenDrawerFontStyle,
//           colorLineSelected: Colors.deepPurpleAccent
//         ),
//         const ConnectWithFriendScreen()
//       ),
//       // ScreenHiddenDrawer(
//       //   ItemHiddenMenu(
//       //     name: 'Sign Out',
//       //     baseStyle: hiddenDrawerFontStyle.copyWith(color: Colors.red), 
//       //     selectedStyle: hiddenDrawerFontStyle,
//       //     colorLineSelected: Colors.red
//       //   ),
//       //   const LogoutScreen()
//       // ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return HiddenDrawerMenu(
//       backgroundColorMenu: const Color.fromARGB(255, 255, 122, 82),
//       screens: _screens,
//       initPositionSelected: 0,
//       backgroundColorAppBar: Colors.deepOrange,
//       isDraggable: false,
//       slidePercent:40,
//       verticalScalePercent: 100,
//       withAutoTittleName: true,
//     );
//   }
// }