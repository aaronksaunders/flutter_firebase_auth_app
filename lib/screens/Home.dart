import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/ItemsList.dart';
import 'package:firebase_auth_app/components/LoadingCircle.dart';
import 'package:firebase_auth_app/screens/AddItem.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firebase"),
      ),
      body: ItemsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItemPage(), fullscreenDialog: true),
              )
            },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
