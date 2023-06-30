import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rspct/constants.dart';



class ConnectWithFriendScreen extends StatefulWidget {
  const ConnectWithFriendScreen({Key? key}) : super(key: key);

  static const id = 'connect_with_friend_screen';

  @override
  State<ConnectWithFriendScreen> createState() => _ConnectWithFriendState();
}

class _ConnectWithFriendState extends State<ConnectWithFriendScreen> {
  final User _user = FirebaseAuth.instance.currentUser!;
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  final Map<String, RspctContact> _contactToRspctContactMap = {};
  // final Map<String, String> _contactToFirebaseIDMap = {};
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getContacts();
    _searchController.addListener(() {
      filterContacts();
    });
  }

  void addTestContacts(List<Contact> contacts) {
    Contact contactDC = Contact(
      displayName: 'Dick Chaney',
      givenName: 'Dick',
      familyName: 'Chaney',
      phones: [Item(value: '5557830741'), Item(value: '5551234987')]
    );
    Contact contactBN = Contact(
      displayName: 'B N',
      givenName: 'B',
      familyName: 'N',
      phones: [Item(value: '5551234568')]
    );
    contacts.add(contactDC);
    contacts.add(contactBN);
  }

  void getContacts() async {
    // 1. get all the contacts from the phone
    List<Contact> contacts = await ContactsService.getContacts();
    
    addTestContacts(contacts);
    
    // 2. from the list of contacts, get the phone numbers and turn to uids
    // 3. access firestore and get the document id's of all the documents that correspond to the uid phone numbers
    List<Contact> availableContacts = [];
    await FirebaseFirestore.instance.collection('user_data').get().then(
      (snapshot) {
        for (var doc in snapshot.docs) {
          for (Contact contact in contacts) {
            for (var number in contact.phones!) {
              String flattenedPhone = flattenPhone(number.value.toString());
              String docPhone = doc['phone_number'];
              if (flattenedPhone == docPhone) {
                // 4. hold these in a map from phone uid to document uid
                // 5. remove the contacts that aren't in the game server
                availableContacts.add(contact);
                // _contactToFirebaseIDMap[doc['phone_number']] = doc.id;
                String name = '${contact.givenName.toString()} ${contact.familyName.toString()}';
                // String initials = '${contact.givenName.toString()[0]}${contact.familyName.toString()[0]}';
                _contactToRspctContactMap[doc['phone_number']] = RspctContact(name: name, docID: doc.id);
              }
            }
          }
        }
      }
    );

    setState(() {
      //_contacts = contacts;
      // 6. present the filtered list
      _contacts = availableContacts;
    });
  }

  void connectContact(String phone, String name) async {
    // 1. get the docID from the map using the given phone id
    // 2. update own collection to now be connected to this new docID
    if (!await isAlreadyConnected(phone)) {
      await FirebaseFirestore.instance.collection('user_data')
        .doc(_user.displayName).collection('contacts').add({
          // 'contactID' : _contactToFirebaseIDMap[phone],
          'contactID' : _contactToRspctContactMap[phone]!.docID,
          'contactName' : _contactToRspctContactMap[phone]!.name,
      });
      connectContactDialog(name);
    } else {
      alreadyConnectedDialog(name);
    }
  }

  Future<bool> isAlreadyConnected(String phone) async {
    bool isConnected = false;
    await FirebaseFirestore.instance.collection('user_data')
      .doc(_user.displayName).collection('contacts').get().then(
      (snapshot) {
        for (var doc in snapshot.docs) {
          String docContactID = doc['contactID'];
          // String mapContactID = _contactToFirebaseIDMap[phone]!;
          String mapContactID = _contactToRspctContactMap[phone]!.docID;
          if (docContactID == mapContactID) {
            isConnected = true;
            break;
          }
        }
      }
    );
    return isConnected;
  }

  Future connectContactDialog(String name) => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: const Text('New Connection!'),
      content: Text('You are now connected with $name'),
      actions: [
        TextButton(
          onPressed: ok, 
          child: const Text('Ok')
        )
      ]
    )
  );

  Future alreadyConnectedDialog(String name) => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: const Text('Already Connected!'),
      content: Text('You and $name are already connected'),
      actions: [
        TextButton(
          onPressed: ok, 
          child: const Text('Ok')
        )
      ],
    )
  );

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

  void filterContacts() {
    List<Contact> contacts = [];
    contacts.addAll(_contacts);
    if (_searchController.text.isNotEmpty) {
      contacts.retainWhere((contact) {
        String searchTerm = _searchController.text.toLowerCase();
        String contactName = contact.displayName!.toLowerCase();
        return contactName.contains(searchTerm);
      });
    }
    setState(() {
      _filteredContacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect with a Friend'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Contacts',
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
                itemCount: isSearching == true ? _filteredContacts.length : _contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = isSearching == true ? _filteredContacts[index] : _contacts[index];
                  return ListTile(
                    title: Text(contact.displayName!),
                    subtitle: Text(contact.phones![0].value!),
                    leading: (contact.avatar != null && contact.avatar!.isNotEmpty) ? 
                      CircleAvatar(
                        backgroundImage: MemoryImage(contact.avatar!),
                      ) : 
                      CircleAvatar(
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Text(contact.initials())
                      ),
                    onTap: () {
                      // 1. get the phone number as a uid
                      String phone = contact.phones![0].value.toString();
                      String name = '${contact.givenName} ${contact.familyName}';

                      // 2. use the phone number to connect contact to Firebase
                      connectContact(flattenPhone(phone), name);
                    },
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}