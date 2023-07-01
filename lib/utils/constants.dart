import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginTextField extends StatelessWidget {
  const LoginTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.obscureText = false})
      : super(key: key);

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }
}

String flattenPhone(String phone) {
  return phone.replaceAll('-', '').replaceAll('(', '').replaceAll(')', '');
}

class RspctContact {
  RspctContact({
    required this.name, 
    required this.docID})
  : initials = '${name[0]}${name[name.indexOf(' ') + 1]}';

  final String name;
  final String docID;
  final String initials;
}

Future<List<RspctContact>> getContactIDsFromUser(String userDocID) async {
  List<RspctContact> contacts = [];
  await FirebaseFirestore.instance.collection('user_data').doc(userDocID)
    .collection('contacts').get().then(
    (snapshot) {
      for (var doc in snapshot.docs) {
        RspctContact contact = RspctContact(name: doc['contactName'], docID: doc['contactID']);
        contacts.add(contact);
      }
    }
  );
  return contacts;
}

drawerNavigation(BuildContext context, Widget screen) {
  Navigator.pop(context);
  Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => screen)
  );
}
