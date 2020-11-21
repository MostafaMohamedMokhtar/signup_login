import 'package:flutter/material.dart';
class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Start Page'),
        ),
        body: Container(
          child: Center(
            child: Text('SignIn Success 😊' ,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),),
          ),
        ),
      ),
    );
  }
}
