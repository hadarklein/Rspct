// import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:fl_score_bar/fl_score_bar.dart';
// import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:rspct/constants.dart';
import 'package:rspct/buttons.dart';
import 'package:rspct/rspct_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rspct/read_data/get_user_data.dart';


class GiveRspctScreen extends StatefulWidget {
  const GiveRspctScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<GiveRspctScreen> createState() => _GiveRspctState();
}

class _GiveRspctState extends State<GiveRspctScreen> {
  int _rating = 0;
  late Future <List<String>> _docIDs;
  // int _docIDsLength = 0;
  String _chosen_friend_docID = '';
  int _chosen_friend_doc_idx = -1;
  String _chosen_friend_str = 'Choose a Friend';
  String _confirmation_text = '';
  final Map<String, String> _ID_Name_map = {};

  void sendRspct() {
    // 1. get the user that corresponds to the chosen_friend_docID
    // 2. update the value based on the _rating chosen
    FirebaseFirestore.instance
      .collection('user_data')
      .doc(_chosen_friend_docID)
      .update(
        {'points': FieldValue.increment(_rating)}
      );

    setState(() {
      _confirmation_text = '${_chosen_friend_str} has received ${_rating} Rspct!';
    });
  }

  void chooseFriend() {
    // need to be in the children of the function that builds the dialog
    // 1. get all the ids/names of the possible friends
    _docIDs = getDocIDs();

    // 2. build the list from there. Should be Expanded -> FutureBuilder , like in home_page_OLD
    // 3. build the list as a ListTile and when one is tapped, save the name/id
    // 4. then close the popup
    chooseFriendDialog();

    // 5. display the chosen name
    
    // call function to bring up a pop up with a list view.
    // choose a name from the list view
    // after choosing the name, update the friend
  }

  Future<String> getNameFromDocID(int doc_idx) async {
    // FirebaseFirestore.instance
    //   .collection('user_data')
    //   .doc(docID)
    //   .get()
    //   .then((snapshot) {
    //     Map<String, dynamic>? data = snapshot.data();
    //     snapshot.
    //   },);
    
    String name = '';
    await FirebaseFirestore.instance.collection('user_data').get().then(
      (snapshot) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.elementAt(doc_idx);
        name = '${doc['first_name']} ${doc['last_name']}';
      }
    );
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

  Future chooseFriendDialog() => showDialog(
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
          child: FutureBuilder<List<String>>(
            future: _docIDs,
            initialData: null,
            builder: (context, snapshot) {
              var data = snapshot.data;
              return SizedBox(
                height: getHeight(data!.length),
                width: 600,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: GetUserName(documentID: snapshot.data![index]),
                        enableFeedback: true,
                        isThreeLine: false,
                        tileColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        onTap: () async {
                          // get the chosen index, docID, name
                          _chosen_friend_doc_idx = index;
                          _chosen_friend_docID = snapshot.data![_chosen_friend_doc_idx];
                          _chosen_friend_str = await getNameFromDocID(_chosen_friend_doc_idx);
                          // refresh the widget with the new variables
                          setState(() {});
                          // pop of the dialog box
                          Navigator.of(context).pop();
                        },
                        
                      ),
                    );
                  }
                ),
              );
            }
          ),
        )
      ],
    ),
  );

  Future<List<String>> getDocIDs() async {
    List<String> docIDs = [];
    
    await FirebaseFirestore.instance.collection('user_data').get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          String id = document.reference.id;
          docIDs.add(id);
          _ID_Name_map[id] = '${document['first_name']} ${document['last_name']}';
        }
      )
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
      appBar: AppBar(
        title: const Text('Give Some Rspct'),
        backgroundColor: Colors.deepOrange,
      ),
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
                    _chosen_friend_str,
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
                itemBuilder: (context, _) => const Icon(RspctIcons.crown_filled, color: Colors.amber,), 
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
                _confirmation_text
              ),
            ],
          )
        ),
      ),
    );
  }

}