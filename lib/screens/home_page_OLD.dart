// // ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:rspct/constants.dart';
// import 'package:rspct/read_data/get_user_data.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final user = FirebaseAuth.instance.currentUser!;

//   // late Future<bool> _future;
//   late Future<List<String>> _docIDs;
//   int docIDslength = 0;

//   Future<List<String>> getDocIDs() async {
//     List<String> docIDs = [];
//     await FirebaseFirestore.instance.collection('user_data').get().then(
//       (snapshot) => snapshot.docs.forEach(
//         (document) {
//           // print(document.reference);
//           docIDs.add(document.reference.id); 
//         }
//       )
//     );
//     docIDslength = docIDs.length;
//     print('docIDslength = ${docIDslength}');
//     return docIDs;
//   }

//   @override
//   void initState() {
//     _docIDs = getDocIDs();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(user.email!),
//         actions: [
//           GestureDetector(
//             child: Icon(Icons.logout_sharp),
//             onTap: () {
//               FirebaseAuth.instance.signOut();
//             }
//           ),
//         ],
//         backgroundColor: Colors.deepOrange,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: FutureBuilder<List<String>>(
//                 future: _docIDs,
//                 initialData: null,
//                 builder: (context, snapshot) {
//                   var data = snapshot.data;
//                   return ListView.builder(
//                     itemCount: data!.length,//     _docIDs..length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: GetUserName(documentID: snapshot.data![index]),//  _docIDs[index]),
//                       );
//                     }
//                   );
//                 }
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
