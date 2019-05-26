import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Flutter Firebase About"),
        //actions: <Widget>[LogoutButton()],
      ),
      body: Text('About Flutter Firebase About Content'),
      drawer: Drawer(
        child: MenuDrawer(),
      ),
    );
  }
}
