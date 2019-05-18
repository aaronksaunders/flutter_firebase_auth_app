import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/LoadingCircle.dart';
import 'package:firebase_auth_app/screens/Home.dart';
import 'package:firebase_auth_app/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/auth.dart';
import './services/data.dart';
import 'model/Item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(stream: AuthService().user),
        StreamProvider<List<Item>>.value(
            stream: DataService().getItemsSnapshot()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: StreamBuilder<FirebaseUser>(
            stream: AuthService().user,
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final bool loggedIn = snapshot.hasData;
                return loggedIn ? HomePage() : LoginPage();
              }
              return LoadingCircle();
            }),
      ),
    );
  }
}
