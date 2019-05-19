import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:firebase_auth_app/services/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetailPage extends StatefulWidget {
  ItemDetailPage({this.itemId});

  final String itemId;

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  String pageTitle = "";
  Future<Item> currentItem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<FirebaseAnalytics>(context)
        .setCurrentScreen(screenName: "ItemDetailPage")
        .then((v) => {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Container(
        child: FutureBuilder<Item>(
            future: currentItem,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(snapshot.data.body),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  void loadItem() async {
    var value = await DataService().getItemById(widget.itemId);

    setState(() {
      pageTitle = value.subject;
      currentItem = new Future<Item>(() => value);
    });
  }
}
