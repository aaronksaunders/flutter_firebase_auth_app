import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth_app/model/Item.dart';
import 'package:firebase_auth_app/services/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AddItem.dart';

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
    super.initState();
    loadItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        actions: <Widget>[
          EditButton(currentItem, () {
            loadItem();
          })
        ],
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
            future: Future.wait([
              currentItem,
              itemUser,
            ]),
            builder: (context, snapshot) {

              if (snapshot.hasData == true) {
                var item = snapshot.data[0];
                var itemOwner = snapshot.data[1];

                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          item.body,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.dueDate,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Text(
                          item != null
                              ? _renderName(itemOwner)
                              : "",
                          style: TextStyle(fontSize: 18),
                        ),
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

  loadItem() async {
    try {
      var value = await DataService().getItemById(widget.itemId);

      setState(() {
        pageTitle = value.subject;
        currentItem = new Future.value(value);
        itemUser = DataService().getUserById(value.owner);
      });
    } catch (e) {
      print(e);
    }
  }
}

class EditButton extends StatelessWidget {
  final Future<Item> currentItem;
  final Function completion;

  const EditButton(
    this.currentItem,
    this.completion, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(Icons.edit),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemPage(this.currentItem),
              settings: RouteSettings(name: "AddItemPage"),
              fullscreenDialog: true,
            ),
          ).then((value) {
            this.completion();
          });
          return true;
        });
  }
}
