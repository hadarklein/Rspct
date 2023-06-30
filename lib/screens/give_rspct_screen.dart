// ignore_for_file: use_build_context_synchronously

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rspct/buttons.dart';
import 'package:rspct/rspct_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rspct/constants.dart';
import 'package:rspct/screens/choose_friend_screen.dart';


class GiveRspctScreen extends StatefulWidget {
  const GiveRspctScreen({Key? key}) : super(key: key);

  static const id = 'give_rspct_screen';

  @override
  State<GiveRspctScreen> createState() => _GiveRspctState();
}

class _GiveRspctState extends State<GiveRspctScreen> {
  // final User _user = FirebaseAuth.instance.currentUser!;
  int _rating = 0;
  RspctContact? _chosenFriend;
  String _chosenFriendStr = 'Choose a Friend';
  String _confirmationText = '';

  void sendRspct() {
    // 0. if chosen friend is still null, show a pop up dialog to tell the user to first choose a friend
    if (_chosenFriend == null) {
      noFriendChosenDialog();
    } else {
      // 1. get the user that corresponds to the chosen_friend_docID
      // 2. update the value based on the _rating chosen
      FirebaseFirestore.instance
        .collection('user_data')
        .doc(_chosenFriend?.docID)
        .update(
          {'points': FieldValue.increment(_rating)}
        );

      setState(() {
        _confirmationText = '$_chosenFriendStr has received $_rating Rspct!';
      });
    }
  }

  Future noFriendChosenDialog() => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: const Text('No Friend Chosen!'),
      content: const Text('You have not selected a friend.\nPlease choose a friend to send some Rspct.'),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
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
                  onPressed: () async {
                    RspctContact? friend = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ChooseFriendScreen();
                        },
                      ),
                    );
                    setState(() {
                      if (friend != null) {
                        _chosenFriend = friend;
                        _chosenFriendStr = friend.name;
                      }
                    });
                  },
                  style: buttonPrimary,
                  child: Text(
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