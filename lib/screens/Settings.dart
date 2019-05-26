import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Settings Flutter Firebase"),
        //actions: <Widget>[LogoutButton()],
      ),
      body: Text('Settings Flutter Firebase  Content'),
      drawer: Drawer(
        child: MenuDrawer(),
      ),
    );
  }
}