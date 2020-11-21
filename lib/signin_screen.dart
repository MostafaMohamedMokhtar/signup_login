import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/config/config.dart';
import 'package:firebase_login/email_pass_signup.dart';
import 'package:firebase_login/phone_signIn_screen.dart';
import 'package:firebase_login/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  FirebaseUser _user;

  bool _obsecure = true;

  File _image;

  final picker = ImagePicker();
  String _imagePth ;

  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }
  void saveImage(String _path) async {
    SharedPreferences preferences  = await SharedPreferences.getInstance() ;
    preferences.setString("imagePath", _path);
  }
  void loadImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance() ;
    setState(() {
      _imagePth =  preferences.getString("imagePath");
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                        saveImage(_image.path);
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                      saveImage(_image.path);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text('View Photo'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  void toggle() {
    setState(() {
      _obsecure = !_obsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  _imagePth !=null
                      ? Container(
                    margin: EdgeInsets.only(top: 80),
                    child: CircleAvatar(
                        radius:70 ,
                        backgroundImage: FileImage(File(_imagePth)),
                    ),
                  )
                 : Container(
                      margin: EdgeInsets.only(top: 80),
                      child: CircleAvatar(
                        radius: 70,
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.file(
                                  _image,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image(
                                image: AssetImage('assets/login2.png'),
                                width: 140,
                                height: 140,
                              ),
                      )
                  ),
                 Container(
                 /*  color: Colors.red,
                   width: 40,
                   height: 40,*/
                   margin: EdgeInsets.only(left: 100, top: 180),
                   child: IconButton(
                     padding: EdgeInsets.only(bottom: 10),
                     icon: Icon(
                       Icons.camera_alt,
                       size: 50,
                       color: Colors.blue,
                     ),
                     onPressed: (){
                       _showPicker(context);
                     },
                   ),
                 )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 40, bottom: 10),
                child: TextField(
                  autofocus: true,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: ' E-mail , phone',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obsecure,
                  decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(_obsecure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          toggle();
                        },
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  _signInWithEmail();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  padding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Center(
                      child: Text(
                    'Login with Email',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailPassSignUpScreen(),
                      ));
                },
                child: Text('Sign-Up using Email'),
              ),
              Wrap(
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      signInWithGoogle();
                    }, // onPressed
                    icon: Icon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    label: Text(
                      'Sign-Up using Google ',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  FlatButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneSignInScreen(),
                            ));
                      },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      label: Text('Sign-Up using phone',
                          style: TextStyle(color: Colors.blue))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithEmail() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StartPage(),
            ));
      }) //  then
          .catchError((error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('Error'),
              content: Text("${error.message}"),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ); // end showDialog
      }); // catchError
    } // end if
    else {
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
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  _passwordController.text = '';
                  _emailController.text = '';
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ); // end showDialog
    }
  } // end signIn()

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      _user = (await _auth.signInWithCredential(credential)).user;
      print('signed in ' + _user.displayName);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StartPage(),
          ));
    } // end try
    catch (e) {
      /*   showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Error'),
            content: Text("${e.message}"),
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
    print('${e.message}') ;*/
    } // end catch
  } // end signInWithGoogle()

} // end class
