import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/config/config.dart';
import 'package:flutter/material.dart';

class EmailPassSignUpScreen extends StatefulWidget {
  @override
  _EmailPassSignUpScreenState createState() => _EmailPassSignUpScreenState();
}

class _EmailPassSignUpScreenState extends State<EmailPassSignUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   FirebaseAuth auth = FirebaseAuth.instance ;

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
    );
  }

  void signUp() {
    final String emailTXT = _emailController.text.trim();
    final String passwordTXT = _passwordController.text;
    if (emailTXT.isNotEmpty && passwordTXT.isNotEmpty) {
      auth.createUserWithEmailAndPassword(
          email: emailTXT,
          password: passwordTXT
      ).then((value){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      }).catchError((e){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
