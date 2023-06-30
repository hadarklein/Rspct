// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rspct/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rspct/buttons.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, /*required this.showLoginScreen*/}) : super(key: key);
  // final VoidCallback showLoginScreen;

  static const id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  // final _displaynameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  
  Future<UserCredential> createUser(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    return result;
  }

  void deleteUser(UserCredential credential) {
    credential.user!.delete();
  }

  void register() async {
    if (passwordConfirmed()) {
      // create a new user so it has access to Firebase in order to search phone numbers
      UserCredential result = await createUser(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );
      
      // check the phone number ID isn't already register
      String phone = flattenPhone(_phoneController.text.trim());
      if (await phoneIdExists(phone)) {
        // if already registered, delete user
        // pop up
        await openPhoneErrorDialog();

        deleteUser(result);
      } else {
        // else register metadata to Firebase
        String userDataId = await addUserData(
          // _displaynameController.text.trim(),
          phone,//_phoneController.text.trim(),
          _firstnameController.text.trim(),
          _lastnameController.text.trim(),
          _emailController.text.trim()
        );

        User? user = result.user;
        user?.updateDisplayName(userDataId);
        // user?.updateDisplayName(_displaynameController.text.trim());
        // Navigator.pop(context);
      }
    } else {
      await openPasswordErrorDialog();
    }
  }

  Future<String> addUserData(/*String displayname,*/ String phone, String firstname, String lastname, String email) async {
    var userDataId = await FirebaseFirestore.instance.collection('user_data').add({
      // 'displayname' : displayname,
      'phone_number' : phone,
      'first_name' : firstname,
      'last_name' : lastname,
      'email' : email,
      'points' : 0
    });
    return userDataId.id;
    // await FirebaseFirestore.instance.collection('user_data').doc(user_data_id.id).collection('connections').add({
    //   'connection_name' : 'blerg',
    //   'connection_id' : 'honk'
    // });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() == 
      _passwordConfirmController.text.trim()) {
      return true;
    }
    return false;
  }

  Future openPasswordErrorDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Password Error!'),
      content: Text('There was a mismatch between the typed passwords'),
      actions: [
        TextButton(
          onPressed: ok,
          child: Text('Ok'),
        )
      ],
    ),
  );

  Future<bool> phoneIdExists(String phone) async {
    bool phoneExists = false;
    // await FirebaseFirestore.instance.collection('user_data').get().then(
    //   (snapshot) => snapshot.docs.forEach(
    //     (doc) {
    //       // String id = doc.reference.id;
    //       if (doc['phone_number'] == phone) {
    //         phoneExists = true;
    //       }
    //     })
    // );
    return phoneExists;
  }
  
  Future openPhoneErrorDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Phone Error!'),
      content: Text('This phone number is already registered'),
      actions: [
        TextButton(
          onPressed: ok, 
          child: Text('Ok')
        )
      ],
    ),
  );

  void ok() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    // _displaynameController.dispose();
    _phoneController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Color.fromARGB(255, 214, 214, 214),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0),
                child: Image.asset(
                  'images/rspct_logo.png',
                ),
              ),

              SizedBox(height: 20.0,),

              // hello again
              Text('Hello There!', style: GoogleFonts.bebasNeue(fontSize: 54)),
              
              SizedBox(height: 10,),

              Text(
                'Welcome. Please Register.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 45),

              // first name textfield
              LoginTextField(
                controller: _firstnameController, 
                hintText: 'First Name'
              ),

              SizedBox(height: 10,),

              // last name textfield
              LoginTextField(
                controller: _lastnameController, 
                hintText: 'Last Name'
              ),

              SizedBox(height: 10,),

              // // display name textfield
              // LoginTextField(controller: _displaynameController, hintText: 'Display Name'),

              // phone number - used as an UID for finding contacts from phone book
              LoginTextField(
                controller: _phoneController, 
                hintText: 'Phone Number'
              ),

              SizedBox(height: 10,),

  
              // email textfield
              LoginTextField(
                controller: _emailController,
                hintText: 'Email'
              ),

              SizedBox(height: 10,),

              // password textfield
              LoginTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              SizedBox(height: 10,),

              // password confirm textfield
              LoginTextField(
                controller: _passwordConfirmController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              SizedBox(height: 10,),

              Container(
                width: 1000,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  onPressed: register,
                  style: buttonPrimary,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20,),

              // register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    // onTap: widget.showLoginScreen,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In Now!',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}


