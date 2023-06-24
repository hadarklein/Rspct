import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rspct/constants.dart';

class ConnectWithFriendScreen extends StatefulWidget {
  const ConnectWithFriendScreen({Key? key}) : super(key: key);

  @override
  State<ConnectWithFriendScreen> createState() => _ConnectWithFriendState();
}

class _ConnectWithFriendState extends State<ConnectWithFriendScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  Map<String, String> _contactToFirebaseIDMap = {};
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
    Contact contact_DC = Contact(
      displayName: 'DickChaney',
      givenName: 'Dick',
      familyName: 'Chaney',
      phones: [Item(value: '5557830741'), Item(value: '5551234987')]
    );
    Contact contact_BN = Contact(
      displayName: 'BN',
      givenName: 'B',
      familyName: 'N',
      phones: [Item(value: '5551234568')]
    );
    contacts.add(contact_DC);
    contacts.add(contact_BN);
  }

  void getContacts() async {
    // 1. get all the contacts from the phone
    List<Contact> contacts = await ContactsService.getContacts();
    
    addTestContacts(contacts);
    
    // 2. from the list of contacts, get the phone numbers and turn to uids
    // 3. access firestore and get the document id's of all the documents that correspond to the uid phone numbers
    List<Contact> available_contacts = [];
    await FirebaseFirestore.instance.collection('user_data').get().then(
      (snapshot) => snapshot.docs.forEach((doc) {
          contacts.forEach((contact) {
            contact.phones?.forEach((number) {
              String flattenedPhone = flattenPhone(number.value.toString());
              String docPhone = doc['phone_number'];
              if (flattenedPhone == docPhone) {
                // 4. hold these in a map from phone uid to document uid
                // 5. remove the contacts that arent in the game server
                available_contacts.add(contact);
                _contactToFirebaseIDMap[doc['phone_number']] = doc.id;
              }
            });
          },);
        }),
    );

    setState(() {
      //_contacts = contacts;
      // 6. present the filtered list
      _contacts = available_contacts;
    });
  }

  void connectContact(String phone) {
    // 1. get the docID from the map using the given phone id
    // 2. update own collection to now be connected to this new docID
    FirebaseFirestore.instance.collection('user_data')
      .doc(user.displayName).collection('contacts').add({
      'contactID' : _contactToFirebaseIDMap[phone],
    });
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
      backgroundColor: Color.fromARGB(255, 232, 232, 232),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: TextField(
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
              )
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
                      // 1. get the phine number as a uid
                      String phone = contact.phones![0].value.toString();

                      // 2. use the phone number to connect contact to Firebase
                      connectContact(flattenPhone(phone));
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