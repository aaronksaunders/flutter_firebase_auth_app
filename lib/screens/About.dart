import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo appInfo = PackageInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appInfo = packageInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Flutter Firebase About"),
        //actions: <Widget>[LogoutButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40.0),
            Text(
              'About Flutter Firebase About Content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.0),
            Text(appInfo?.appName ?? "App Name Missing"),
            Text("Version ${appInfo?.version}"),
            Text("Build  ${appInfo?.buildNumber}"),
          ],
        ),
      ),
      drawer: Drawer(
        child: MenuDrawer(),
      ),
    );
  }
}
