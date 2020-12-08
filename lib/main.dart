import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/config/config.dart';
import 'package:firebase_login/signin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String host = defaultTargetPlatform == TargetPlatform.android
    ? '10.0.2.2:8080'
    : 'localhost:8080';
main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      Settings(host: host, sslEnabled: false);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //themeMode: ThemeMode.system,
      home: HomePage() ,
      theme: ThemeData(
        brightness: Brightness.light ,
        primaryColor: primaryColor ,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark ,
        primaryColor: primaryColor
      ),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SigninScreen(),
    );
  }
}


