import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/LoadingCircle.dart';
import 'package:firebase_auth_app/screens/Home.dart';
import 'package:firebase_auth_app/screens/Login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: StreamBuilder<String>(
          stream: FirebaseAuth.instance.onAuthStateChanged.map(
            (FirebaseUser user) => user?.uid,
          ),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final bool loggedIn = snapshot.hasData;
              return loggedIn ? HomePage() : LoginPage();
            }
            return LoadingCircle();
          }),
    );
  }
}
