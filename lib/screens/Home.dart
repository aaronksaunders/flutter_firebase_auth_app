import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/ItemsList.dart';
import 'package:firebase_auth_app/components/LoadingCircle.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // helper to make sure we are logged on before rendering the UI
  Future<FirebaseUser> checkUser() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      var user = await _auth.signInWithEmailAndPassword(
          email: 'bs@mail.com', password: 'password');
      print(" Current User $user");
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new FutureBuilder<FirebaseUser>(
        future: checkUser(), // a Future<User> or null
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ItemsList();
            default:
              return LoadingCircle();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
