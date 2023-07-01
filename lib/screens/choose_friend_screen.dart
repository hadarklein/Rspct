import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rspct/utils/constants.dart';


class ChooseFriendScreen extends StatefulWidget {
  const ChooseFriendScreen({ Key? key,}) : super(key: key);

  static const id = 'choose_friend_screen';

  @override
  State<ChooseFriendScreen> createState() => _ChooseFriendScreenState();
}

class _ChooseFriendScreenState extends State<ChooseFriendScreen> {
  final _user = FirebaseAuth.instance.currentUser!;
  List<RspctContact> _friends = [];
  List<RspctContact> _filteredFriends= [];
  final _searchController = TextEditingController();
  
  
  @override
  void initState() {
    super.initState();

    getFriendsDocIDs();
    _searchController.addListener(() {
      filterFriends();
    });
  }

  getFriendsDocIDs() async {
    _friends = await getContactIDsFromUser(_user.displayName.toString());
    setState(() {
      
    });
  }

  void filterFriends() {
    
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Choose a Friend'),
      ),
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Friends',
                  labelStyle: TextStyle(
                    color: Colors.deepPurpleAccent
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurpleAccent
                    )
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.deepPurpleAccent,)
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: isSearching == true ? _filteredFriends.length : _friends.length,
                  itemBuilder: (context, index) {
                    RspctContact friend = isSearching == true ? _filteredFriends[index] : _friends[index];
                    return ListTile(
                      title: Text(friend.name),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Text(friend.initials),
                      ),
                      onTap: () {
                        Navigator.pop(context, friend);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
