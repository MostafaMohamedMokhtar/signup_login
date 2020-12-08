import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/config/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class EmailPassSignUpScreen extends StatefulWidget {
  @override
  _EmailPassSignUpScreenState createState() => _EmailPassSignUpScreenState();
}

class _EmailPassSignUpScreenState extends State<EmailPassSignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage _storage ;
 // FirebaseStorage _storage ;

  User user;

  FirebaseFirestore _db;

  bool _initialized = false;
  bool _error = false;
  File file;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 40, bottom: 10),
                child: TextField(
                  autofocus: true,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Enter your e-mail',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              InkWell(
                onTap: () {
                  signUp();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Center(
                      child: Text(
                    'Sign Up with Email',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [primaryColor, secondaryColor]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _getFile();
        },
      ),
    );
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'full_name': 'Mostafa', // John Doe
          'company': 'Stokes and Sons', // Stokes and Sons
          'age': '42' // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void _getFile() async {
    //File file = await FilePicker.
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      setState(() {
        if (result != null) {
         // file = File(result.files.single.path);
          File file = result.files.first as File;
          print('///// file path :  ${file.path}');
          _uploadFile(file.path);

        }
      });
    } catch (e) {
     // print(e.message);
    }
  } // end _getFile()

  void _uploadFile(String  filePath ) async {
    _storage = await firebase_storage.FirebaseStorage.instance ;
    File file = File(filePath);
    String fileName = path.basename(file.path);
    try{
      _storage.ref().child('images').child(fileName).putFile(file);
    }catch( e ){
      //print('///// error : ${e.message}') ;
    }

/*    try {
      UploadTask uploadTask = _storage.ref().child('images').child(fileName).putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        if(event.runtimeType == TaskState.running){
          print('${event.bytesTransferred} of ${event.totalBytes}');
        }
        if(event.runtimeType == TaskState.success){
          event.ref.getDownloadURL().then((url) {
            print(url) ;
          });
        }
      });
    }  catch (e) {
      print(e.message);
    }*/

  }// end _uploadFile()

  void signUp() async {
    final String emailTXT = _emailController.text.trim();
    final String passwordTXT = _passwordController.text;
    // user = await FirebaseAuth.instance.currentUser ;
    _db = await FirebaseFirestore.instance;
    Map<String, Object> _user = {
      "email": emailTXT,
      "lastSeen": DateTime.now(),
    };

    if (emailTXT.isNotEmpty && passwordTXT.isNotEmpty) {
      auth
          .createUserWithEmailAndPassword(
              email: emailTXT, password: passwordTXT)
          .then((value) {
        print('///////////////////userid = ${value.user.uid}');

        _db.collection('users').doc(value.user.uid).set(
            /*   {
          "email" : emailTXT ,
          "lastSeen" : DateTime.now() ,
          "signin_method" : value.user.providerData
        }*/
            _user);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('success'),
              content: Text(' SignUp process Done'),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ); // e
      }).catchError((e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('Error'),
              content: Text('${e.message}'),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ); // end showDialog()
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Error'),
            content: Text(' please write Email and password...'),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ); // end showDialog
    }
  } // end signUp()
}
