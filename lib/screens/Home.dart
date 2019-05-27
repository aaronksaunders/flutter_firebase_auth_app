import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/ItemsList.dart';
import 'package:firebase_auth_app/components/MenuDrawer.dart';

import 'package:firebase_auth_app/screens/AddItem.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("drawing Home Page");
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firebase"),
        actions: <Widget>[LogoutButton()],
      ),
      // body: StreamProvider<List<Item>>.value(
      //   // when this stream changes, the children will get
      //   // updated appropriately
      //   stream: DataService().getItemsSnapshot(),
      //   child: ItemsList(),
      // ),
      body: ItemsList(),
      drawer: Drawer(
        child: FutureBuilder<FirebaseUser>(
            future: AuthService().getUser,
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Provider.of<MenuStateInfo>(context)
                    .setCurrentUser(snapshot.data);
                return MenuDrawer();
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddItemPage(),
                settings: RouteSettings(name: "AddItemPage"),
                fullscreenDialog: true),
          );
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(Icons.exit_to_app),
        onPressed: () async {
          await AuthService().logout();

          // Navigator.pushReplacementNamed(context, "/");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: "LoginPage"),
                builder: (BuildContext context) => LoginPage()),
          );
        });
  }
}
