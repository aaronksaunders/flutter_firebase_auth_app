import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/LoadingCircle.dart';
import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:firebase_auth_app/screens/Home.dart';
import 'package:firebase_auth_app/screens/Login.dart';
import 'package:firebase_auth_app/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    print("drawing Main Page");

    return MultiProvider(
      providers: [
        Provider<MenuStateInfo>.value(
          value: MenuStateInfo("HomePage"),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: "/",
        home: FutureBuilder<FirebaseUser>(
            future: AuthService().getUser,
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print("drawing main: target screen" +
                    snapshot.connectionState.toString());
                final bool loggedIn = snapshot.hasData;
                return loggedIn ? HomePage() : LoginPage();
              } else {
                print("drawing main: loading circle" +
                    snapshot.connectionState.toString());
                return LoadingCircle();
              }
            }),
      ),
    );
  }
}
