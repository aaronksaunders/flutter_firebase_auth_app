import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<ItemOwner> itemUser;

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
                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          snapshot.data.body,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data.dueDate,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        FutureBuilder<ItemOwner>(
                            future: itemUser,
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data != null
                                    ? _renderName(snapshot.data)
                                    : "",
                                style: TextStyle(fontSize: 18),
                              );
                            }),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  String _renderName(ItemOwner data) {
    return '${data.firstName} ${data.lastName}';
  }

  void loadItem() async {
    var value = await DataService().getItemById(widget.itemId);

    setState(() {
      pageTitle = value.subject;
      currentItem = new Future<Item>(() => value);
      itemUser = DataService().getUserById(value.owner);
    });
  }
}
