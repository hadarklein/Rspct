import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserName extends StatelessWidget {
  const GetUserName({super.key, required this.documentID});
  final String documentID;
  
  @override
  Widget build(BuildContext context) {
    // get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('user_data');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          // Map<String, dynamic> data = 
          //snapshot.data!.data();// as Map<String, dynamic>;
          // return Text('First name: ${data['first_name']}');
          return Text('${data['first_name']} ${data['last_name']}');
        }
        return const Text('Loading...');
      }),
    );
  }
}
