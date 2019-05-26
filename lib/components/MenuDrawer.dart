import 'package:firebase_auth_app/screens/About.dart';
import 'package:firebase_auth_app/screens/Home.dart';
import 'package:firebase_auth_app/screens/Settings.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  String _currentMenuItem = "HomePage";

  // MenuDrawer({
  //   Key key,
  // }) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  Future _gotoPage(Widget _page, BuildContext _context) {
    setState(() {
      widget._currentMenuItem = _page.runtimeType.toString();
    });
    Navigator.of(_context).pop();
    return Navigator.of(_context).pushReplacement(
      MaterialPageRoute(
          settings: RouteSettings(name: _page.runtimeType.toString()),
          builder: (BuildContext context) => _page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header '),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: widget._currentMenuItem == "HomePage"
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : TextStyle(fontWeight: FontWeight.normal),
            ),
            onTap: () {
              _gotoPage(HomePage(), context);
            },
          ),
          ListTile(
            title: Text(
              'Settings',
              style: widget._currentMenuItem == "SettingsPage"
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : TextStyle(fontWeight: FontWeight.normal),
            ),
            onTap: () {
              _gotoPage(SettingsPage(), context);
            },
          ),
          ListTile(
            title: Text(
              'About This App',
              style: widget._currentMenuItem == "AboutPage"
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : TextStyle(fontWeight: FontWeight.normal),
            ),
            onTap: () {
              _gotoPage(AboutPage(), context);
            },
          ),
        ],
      ),
    );
  }
}
