// import 'dart:ffi';

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rspct/buttons.dart';
import 'package:rspct/rspct_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rspct/read_data/get_user_data.dart';
import 'package:rspct/constants.dart';


class GiveRspctScreen extends StatefulWidget {
  const GiveRspctScreen({Key? key}) : super(key: key);

  @override
  State<GiveRspctScreen> createState() => _GiveRspctState();
}

class _GiveRspctState extends State<GiveRspctScreen> {
  final User _user = FirebaseAuth.instance.currentUser!;
  int _rating = 0;
  String _chosenFriendDocID = '';
  String _chosenFriendStr = 'Choose a Friend';
  String _confirmationText = '';
  final Map<String, String> _idNameMap = {};

  void sendRspct() {
    // 1. get the user that corresponds to the chosen_friend_docID
    // 2. update the value based on the _rating chosen
    FirebaseFirestore.instance
      .collection('user_data')
      .doc(_chosenFriendDocID)
      .update(
        {'points': FieldValue.increment(_rating)}
      );

    setState(() {
      _confirmationText = '$_chosenFriendStr has received $_rating Rspct!';
    });
  }

  void chooseFriend() async {
    // 1. get all the ids/names of the user's registered connections
    // List<String> docIDs = getDocIDs();
    List<String> docIDs = await getDocIDs2();

    // 2. check to see if the user has any connections already
    if (docIDs.isEmpty) {
      // 2.a. if not, show a pop up informing the user to register connections
      noFriendsDialog();
    } else {
      // 2.b. if yes:
      // 3. build the list as a ListTile and when one is tapped, save the name/id
      // 4. then close the popup
      // 5. display the chosen name - not implemented yet
      chooseFriendDialog(docIDs);
    }
  }

  Future<String> getNameFromDocID(String docID) async {
    String name = '';
    await FirebaseFirestore.
      instance.collection('user_data').doc(docID).get().then(
        (snapshot) {
          Map<String, dynamic>? doc = snapshot.data();
          name = '${doc?['first_name']} ${doc?['last_name']}';
      },);

    // String name = '';
    // await FirebaseFirestore.instance.collection('user_data').get().then(
    //   (snapshot) {
    //     QueryDocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.elementAt(docIdx);
    //     name = '${doc['first_name']} ${doc['last_name']}';
    //   }
    // );
    return name;
  }

  double getHeight(int len) {
    double lengthDbl = len.toDouble();
    if (lengthDbl <= 3) {
      return 200;
    } else {
      return 30 * lengthDbl;
    }
  }

  Future noFriendsDialog() => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: const Text('No Registered Contacts!'),
      content: const Text('You have not connected any of your contacts.\nPlease choose at least 1 contact to play with.'),
      actions: [
        TextButton(
          onPressed: ok,
          child: const Text('Ok'),
        )
      ],
    )
  );

  void ok() {
    Navigator.of(context).pop();
  }

  Future chooseFriendDialog(List<String> docIDs) => showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text(
        'Choose a Friend',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
      backgroundColor: Colors.deepOrangeAccent,
      children: [
        Expanded(
          child: SizedBox(
            height: getHeight(docIDs.length),
            width: 600,
            child: ListView.builder(
              itemCount: docIDs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: GetUserName(documentID: docIDs[index]),
                    enableFeedback: true,
                    isThreeLine: false,
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    onTap: () async {
                      // get the chosen index, docID, name
                      _chosenFriendDocID = docIDs[index];
                      _chosenFriendStr = await getNameFromDocID(_chosenFriendDocID);
                      // refresh the widget with the new variables
                      setState(() {});
                      // pop off the dialog box
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }
            ),
          )
        ),
      ],
    ),
  );

  Future<List<String>> getDocIDs() async {
    List<String> docIDs = [];
    
    await FirebaseFirestore.instance.collection('user_data').get().then(
      (snapshot) {
        for (var doc in snapshot.docs) {
          String id = doc.reference.id;
          docIDs.add(id);
          _idNameMap[id] = '${doc['first_name']} ${doc['last_name']}';
        }
      }
      // (snapshot) => snapshot.docs.forEach(
      //   (document) {
      //     String id = document.reference.id;
      //     docIDs.add(id);
      //     _idNameMap[id] = '${document['first_name']} ${document['last_name']}';
      //   }
      // )
    );
    return docIDs;
  }

  Future<List<String>> getDocIDs2() async {
    List<String> docIDs = [];
    await FirebaseFirestore.instance.collection('user_data').doc(_user.displayName)
      .collection('contacts').get().then(
      (snapshot) {
        for (var doc in snapshot.docs) {
          docIDs.add(doc['contactID']);
        }
      }
      // (snapshot) => snapshot.docs.forEach(
      //   (doc) {
      //     docIDs.add(doc['contactID']);
      //   }
      // )
    );
    return docIDs;
  }

  @override
  void initState() {
    // _docIDs = getDocIDs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      // appBar: AppBar(
      //   title: const Text('Give Some Rspct'),
      //   backgroundColor: Colors.deepOrange,
      // ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // choose a friend to send points to
              Container(
                width: 1000,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  onPressed: chooseFriend,
                  style: buttonPrimary,
                  child: Text(
                    // friend,
                    _chosenFriendStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height:200,),

              // choose number of points to give
              RatingBar.builder(
                initialRating: 0,
                minRating: 0,
                maxRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 47.5,
                itemPadding: const EdgeInsets.all(5),
                unratedColor: Colors.grey.withAlpha(50),
                itemBuilder: (context, _) => const Icon(RspctIcons.crownFilled, color: Colors.amber,), 
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating.toInt();
                    // print('RatingBar rating updated -> $_rating');
                  });
                }
              ),
              const SizedBox(height: 50,),

              // Apply button
              RspctButtonStateless(text: 'Give Rspct', func: sendRspct),
              const SizedBox(height: 50,),

              Text(
                _confirmationText
              ),
            ],
          )
        ),
      ),
    );
  }
}